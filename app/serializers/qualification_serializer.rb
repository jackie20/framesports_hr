class QualificationSerializer
  include JSONAPI::Serializer
  set_type :employee_qualification

  attributes :institution_name, :qualification_name, :field_of_study,
             :year_obtained, :expiry_date, :is_verified, :verified_at, :notes

  attribute :qualification_type do |obj|
    obj.qualification_type_lookup ? { id: obj.qualification_type_lookup.id, code: obj.qualification_type_lookup.code, value: obj.qualification_type_lookup.value } : nil
  end
end
