class LookupValueSerializer
  include JSONAPI::Serializer
  set_type :lookup_value

  attributes :code, :value, :description, :is_active, :sort_order

  attribute :meta do |obj|
    obj.meta
  end
end
