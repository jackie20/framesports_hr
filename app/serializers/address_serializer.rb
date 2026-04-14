class AddressSerializer
  include JSONAPI::Serializer
  set_type :employee_address

  attributes :line1, :line2, :suburb, :city, :province_state,
             :postal_code, :country, :is_primary, :effective_from

  attribute :address_type do |obj|
    obj.address_type_lookup ? { id: obj.address_type_lookup.id, code: obj.address_type_lookup.code, value: obj.address_type_lookup.value } : nil
  end
end
