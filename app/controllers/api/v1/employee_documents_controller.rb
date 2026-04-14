module Api
  module V1
    class EmployeeDocumentsController < ApplicationController
      before_action :set_employee
      before_action :set_document, only: [:show, :update, :destroy]

      def index
        require_permission!("documents.view_own", "documents.view_all")
        docs = can_view_all_documents? ? @employee.employee_documents.kept : @employee.employee_documents.kept.not_confidential
        render_success(docs.map { |d| DocumentSerializer.new(d).serializable_hash[:data] })
      end

      def show
        require_permission!("documents.view_own", "documents.view_all")
        render_success(DocumentSerializer.new(@document).serializable_hash[:data])
      end

      def create
        require_permission!("documents.upload_own", "documents.view_all")
        doc = @employee.employee_documents.build(
          document_params.merge(uploaded_by_id: current_employee.id)
        )
        if doc.save
          render_created(DocumentSerializer.new(doc).serializable_hash[:data])
        else
          render_record_errors(doc)
        end
      end

      def update
        require_permission!("documents.view_all")
        if @document.update(document_params)
          render_success(DocumentSerializer.new(@document).serializable_hash[:data])
        else
          render_record_errors(@document)
        end
      end

      def destroy
        if current_employee.has_permission?("documents.delete_all") ||
           (@document.uploaded_by_id == current_employee.id && current_employee.has_permission?("documents.delete_own"))
          @document.discard
          render_no_content
        else
          render json: error_response("Forbidden", "You cannot delete this document", status: 403), status: :forbidden
        end
      end

      private

      def set_employee
        @employee = Employee.active.find(params[:employee_id])
      end

      def set_document
        @document = @employee.employee_documents.kept.find(params[:id])
      end

      def document_params
        params.require(:employee_document).permit(
          :document_type_lookup_id, :title, :description,
          :issue_date, :expiry_date, :is_confidential,
          :file_path, :file_name, :content_type, :file_size
        )
      end

      def can_view_all_documents?
        current_employee.has_permission?("employees.view_sensitive") ||
          current_employee.has_permission?("documents.view_all")
      end
    end
  end
end
