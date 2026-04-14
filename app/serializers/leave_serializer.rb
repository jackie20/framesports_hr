class LeaveSerializer
  include JSONAPI::Serializer
  set_type :employee_leave

  attributes :start_date, :end_date, :days_requested, :reason, :reviewed_at, :review_comment, :created_at

  attribute :employee do |obj|
    obj.employee ? { id: obj.employee.id, full_name: obj.employee.full_name, employee_number: obj.employee.employee_number } : nil
  end

  attribute :leave_type do |obj|
    obj.leave_type_lookup ? { id: obj.leave_type_lookup.id, code: obj.leave_type_lookup.code, value: obj.leave_type_lookup.value } : nil
  end

  attribute :status do |obj|
    obj.status_lookup ? { id: obj.status_lookup.id, code: obj.status_lookup.code, value: obj.status_lookup.value } : nil
  end

  attribute :reviewer do |obj|
    obj.reviewer ? { id: obj.reviewer.id, full_name: obj.reviewer.full_name } : nil
  end
end
