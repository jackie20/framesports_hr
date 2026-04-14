class LeaveBalanceSerializer
  include JSONAPI::Serializer
  set_type :leave_balance

  attributes :year, :total_days, :used_days, :pending_days, :carried_over_days

  attribute :available_days do |obj|
    obj.available_days
  end

  attribute :leave_type do |obj|
    obj.leave_type_lookup ? { id: obj.leave_type_lookup.id, code: obj.leave_type_lookup.code, value: obj.leave_type_lookup.value } : nil
  end
end
