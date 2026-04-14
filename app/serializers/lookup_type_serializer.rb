class LookupTypeSerializer
  include JSONAPI::Serializer
  set_type :lookup_type

  attributes :code, :name, :description, :is_system, :is_active, :sort_order

  attribute :values do |obj|
    obj.lookup_values.active.ordered.map do |v|
      { id: v.id, code: v.code, value: v.value, sort_order: v.sort_order, is_active: v.is_active }
    end
  end
end
