module Api
  module V1
    class SharedFilesController < ApplicationController
      before_action :set_file, only: [:show, :update, :destroy]

      # GET /api/v1/files
      def index
        require_permission!("files.view")
        files = paginate(SharedFile.visible_to(current_employee).includes(:uploaded_by, :file_category_lookup).order(created_at: :desc))
        render_collection(files.map { |f| SharedFileSerializer.new(f).serializable_hash[:data] })
      end

      # GET /api/v1/files/:id
      def show
        require_permission!("files.view")
        render_success(SharedFileSerializer.new(@file).serializable_hash[:data])
      end

      # POST /api/v1/files
      def create
        require_permission!("files.upload")
        file = SharedFile.new(file_params.merge(uploaded_by: current_employee))

        if file.save
          if params[:employee_ids].present? && file.visibility == "specific"
            Array(params[:employee_ids]).each do |eid|
              file.shared_file_employees.create(employee_id: eid, shared_at: Time.current)
            end
          end
          render_created(SharedFileSerializer.new(file).serializable_hash[:data])
        else
          render_record_errors(file)
        end
      end

      # PUT /api/v1/files/:id
      def update
        require_permission!("files.upload")
        unless can_manage_file?
          return render json: error_response("Forbidden", "Access denied", status: 403), status: :forbidden
        end
        if @file.update(file_params)
          render_success(SharedFileSerializer.new(@file).serializable_hash[:data])
        else
          render_record_errors(@file)
        end
      end

      # DELETE /api/v1/files/:id
      def destroy
        if current_employee.has_permission?("files.delete_all") ||
           (@file.uploaded_by_id == current_employee.id && current_employee.has_permission?("files.delete_own"))
          @file.update!(is_active: false)
          render_no_content
        else
          render json: error_response("Forbidden", "You cannot delete this file", status: 403), status: :forbidden
        end
      end

      private

      def set_file
        @file = SharedFile.active.find(params[:id])
      end

      def file_params
        params.require(:shared_file).permit(
          :title, :description, :file_category_lookup_id,
          :visibility, :team_id, :file_path, :file_name, :content_type, :file_size
        )
      end

      def can_manage_file?
        current_employee.has_permission?("files.manage_categories") ||
          @file.uploaded_by_id == current_employee.id
      end
    end
  end
end
