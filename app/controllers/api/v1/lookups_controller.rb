module Api
  module V1
    class LookupsController < ApplicationController
      # GET /api/v1/lookups
      def index
        types = LookupType.active.ordered.includes(:lookup_values)
        render_success(types.map { |t| LookupTypeSerializer.new(t).serializable_hash[:data] })
      end

      # GET /api/v1/lookups/:type_code
      def show
        type = LookupType.active.find_by!(code: params[:type_code].downcase)
        render_success(LookupTypeSerializer.new(type, include: [:lookup_values]).serializable_hash[:data])
      end
    end
  end
end
