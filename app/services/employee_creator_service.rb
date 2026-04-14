class EmployeeCreatorService < ApplicationService
  def initialize(params:, created_by:)
    @params     = params
    @created_by = created_by
  end

  def call
    employee = Employee.new(@params.merge(created_by: @created_by))

    if employee.save
      assign_default_role!(employee)
      create_default_leave_balances!(employee)
      notify_hr!(employee)
      success(employee)
    else
      failure(employee.errors.full_messages.join(", "), employee)
    end
  rescue => e
    failure(e.message)
  end

  private

  def assign_default_role!(employee)
    default_role = Role.find_by(code: "employee")
    return unless default_role

    UserRole.find_or_create_by!(
      employee: employee,
      role:     default_role
    ) do |ur|
      ur.assigned_by = @created_by
      ur.assigned_at = Time.current
    end
  end

  def create_default_leave_balances!(employee)
    current_year = Date.today.year
    leave_types  = LookupType.values_for(:leave_type)

    default_days = {
      "annual"               => 15,
      "sick"                 => 30,
      "family_responsibility" => 3
    }

    leave_types.each do |lt|
      days = default_days[lt.code] || 0
      LeaveBalance.find_or_create_by!(
        employee:             employee,
        leave_type_lookup_id: lt.id,
        year:                 current_year
      ) do |lb|
        lb.total_days = days
      end
    end
  end

  def notify_hr!(employee)
    hr_employees = Employee.active
                           .joins(roles: :permissions)
                           .where(permissions: { code: "employees.view_all" })
                           .distinct

    hr_employees.each do |hr|
      NotificationService.send_to(
        employee:  hr,
        type_code: "system",
        title:     "New Employee Onboarded",
        body:      "#{employee.full_name} (#{employee.employee_number}) has been added.",
        resource:  employee,
        url:       "/employees/#{employee.id}"
      )
    end
  end
end
