class UniformSerializer
  include JSONAPI::Serializer
  set_type :employee_uniform

  attributes :trouser_waist_cm, :trouser_length_cm, :shoe_size, :cap_size, :notes

  attribute :shirt_size do |obj|
    obj.shirt_size_lookup ? { id: obj.shirt_size_lookup.id, code: obj.shirt_size_lookup.code, value: obj.shirt_size_lookup.value } : nil
  end

  attribute :jacket_size do |obj|
    obj.jacket_size_lookup ? { id: obj.jacket_size_lookup.id, code: obj.jacket_size_lookup.code, value: obj.jacket_size_lookup.value } : nil
  end

  attribute :shoe_size_system do |obj|
    obj.shoe_size_system_lookup ? { id: obj.shoe_size_system_lookup.id, code: obj.shoe_size_system_lookup.code, value: obj.shoe_size_system_lookup.value } : nil
  end
end
