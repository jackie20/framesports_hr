class EmployeeSearchQuery
  attr_reader :scope, :params

  def initialize(scope = Employee.active, params = {})
    @scope  = scope
    @params = params
  end

  def call
    result = scope
    result = filter_by_department(result)
    result = filter_by_name(result)
    result = filter_by_team(result)
    result = filter_by_employment_type(result)
    result = filter_by_onboarding(result)
    result = filter_by_active(result)
    result.order(last_name: :asc, first_name: :asc)
  end

  private

  def filter_by_department(s)
    return s unless params[:department].present?
    s.joins(:department_lookup).where(lookup_values: { code: params[:department] })
  end

  def filter_by_name(s)
    return s unless params[:q].present?
    term = "%#{params[:q].strip}%"
    s.where("first_name LIKE :q OR last_name LIKE :q OR work_email LIKE :q OR employee_number LIKE :q", q: term)
  end

  def filter_by_team(s)
    return s unless params[:team_id].present?
    s.joins(:team_members).where(team_members: { team_id: params[:team_id], is_active: true })
  end

  def filter_by_employment_type(s)
    return s unless params[:employment_type].present?
    s.joins(:employment_type_lookup).where(lookup_values: { code: params[:employment_type] })
  end

  def filter_by_onboarding(s)
    return s if params[:onboarding_complete].blank?
    s.where(is_onboarding_complete: params[:onboarding_complete] == "true")
  end

  def filter_by_active(s)
    return s if params[:include_inactive] == "true"
    s.where(is_active: true)
  end
end
