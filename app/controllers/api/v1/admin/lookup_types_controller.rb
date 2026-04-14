module Api
  module V1
    module Admin
      class LookupTypesController < ApplicationController
        before_action :set_lookup_type, only: [:show, :update, :destroy]

        def index
          require_permission!("admin.lookups.manage")
          types = LookupType.ordered.includes(:lookup_values)
          render_success(types.map { |t| LookupTypeSerializer.new(t).serializable_hash[:data] })
        end

        def show
          require_permission!("admin.lookups.manage")
          render_success(LookupTypeSerializer.new(@type, include: [:lookup_values]).serializable_hash[:data])
        end

        def create
          require_permission!("admin.lookups.manage")
          type = LookupType.new(lookup_type_params.merge(created_by: current_employee))
          if type.save
            render_created(LookupTypeSerializer.new(type).serializable_hash[:data])
          else
            render_record_errors(type)
          end
        end

        def update
          require_permission!("admin.lookups.manage")
          if @type.is_system && !current_employee.has_permission?("admin.system")
            return render json: error_response("Forbidden", "System lookup types cannot be modified", status: 403), status: :forbidden
          end
          if @type.update(lookup_type_params)
            render_success(LookupTypeSerializer.new(@type).serializable_hash[:data])
          else
            render_record_errors(@type)
          end
        end

        def destroy
          require_permission!("admin.lookups.manage")
          if @type.is_system
            return render json: error_response("Forbidden", "System lookup types cannot be deleted", status: 403), status: :forbidden
          end
          @type.update!(is_active: false)
          render_no_content
        end

        private

        def set_lookup_type
          @type = LookupType.find(params[:id])
        end

        def lookup_type_params
          params.require(:lookup_type).permit(:code, :name, :description, :sort_order)
        end
      end
    end
  end
end
