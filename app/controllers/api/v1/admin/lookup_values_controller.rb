module Api
  module V1
    module Admin
      class LookupValuesController < ApplicationController
        before_action :set_lookup_type
        before_action :set_value, only: [:show, :update, :destroy]

        def index
          require_permission!("admin.lookups.manage")
          render_success(@type.lookup_values.ordered.map { |v| LookupValueSerializer.new(v).serializable_hash[:data] })
        end

        def show
          require_permission!("admin.lookups.manage")
          render_success(LookupValueSerializer.new(@value).serializable_hash[:data])
        end

        def create
          require_permission!("admin.lookups.manage")
          value = @type.lookup_values.build(value_params)
          if value.save
            render_created(LookupValueSerializer.new(value).serializable_hash[:data])
          else
            render_record_errors(value)
          end
        end

        def update
          require_permission!("admin.lookups.manage")
          if @value.update(value_params)
            render_success(LookupValueSerializer.new(@value).serializable_hash[:data])
          else
            render_record_errors(@value)
          end
        end

        def destroy
          require_permission!("admin.lookups.manage")
          @value.update!(is_active: false)
          render_no_content
        end

        private

        def set_lookup_type
          @type = LookupType.find(params[:lookup_type_id])
        end

        def set_value
          @value = @type.lookup_values.find(params[:id])
        end

        def value_params
          params.require(:lookup_value).permit(:code, :value, :description, :meta_json, :is_active, :sort_order)
        end
      end
    end
  end
end
