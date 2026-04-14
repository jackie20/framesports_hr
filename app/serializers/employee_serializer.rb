class EmployeeSerializer
  include JSONAPI::Serializer

  set_type :employee

  attributes :employee_number, :first_name, :middle_name, :last_name,
             :preferred_name, :work_email, :personal_email,
             :phone_mobile, :phone_work, :job_title,
             :date_of_birth, :nationality, :start_date, :end_date,
             :is_active, :is_onboarding_complete, :onboarding_completed_at,
             :last_login_at, :created_at

  attribute :full_name

  attribute :title do |obj|
    obj.title_lookup ? { id: obj.title_lookup.id, code: obj.title_lookup.code, value: obj.title_lookup.value } : nil
  end

  attribute :gender do |obj|
    obj.gender_lookup ? { id: obj.gender_lookup.id, code: obj.gender_lookup.code, value: obj.gender_lookup.value } : nil
  end

  attribute :marital_status do |obj|
    obj.marital_status_lookup ? { id: obj.marital_status_lookup.id, code: obj.marital_status_lookup.code, value: obj.marital_status_lookup.value } : nil
  end

  attribute :employment_type do |obj|
    obj.employment_type_lookup ? { id: obj.employment_type_lookup.id, code: obj.employment_type_lookup.code, value: obj.employment_type_lookup.value } : nil
  end

  attribute :department do |obj|
    obj.department_lookup ? { id: obj.department_lookup.id, code: obj.department_lookup.code, value: obj.department_lookup.value } : nil
  end

  has_many :employee_addresses, serializer: AddressSerializer
  has_many :employee_qualifications, serializer: QualificationSerializer
  has_one  :employee_uniform, serializer: UniformSerializer
  has_many :roles, serializer: RoleSerializer
end
