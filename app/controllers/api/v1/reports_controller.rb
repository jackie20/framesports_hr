module Api
  module V1
    class ReportsController < ApplicationController
      REPORT_PERMISSIONS = {
        "headcount"           => "reports.view_all",
        "leave_summary"       => "reports.view_team",
        "onboarding_status"   => "reports.view_all",
        "team_roster"         => "reports.view_team",
        "document_expiry"     => "reports.view_all",
        "qualification_matrix" => "reports.view_all",
        "task_completion"     => "reports.view_team",
        "personal_summary"    => "reports.view_self"
      }.freeze

      # GET /api/v1/reports/:code
      def show
        code       = params[:code]
        permission = REPORT_PERMISSIONS[code]

        unless permission
          return render json: error_response("Not Found", "Unknown report: #{code}", status: 404), status: :not_found
        end

        require_permission!(permission)

        filters = filter_params
        report  = generate_report(code, filters)

        render_success({
          report_code:     code,
          generated_at:    Time.current.iso8601,
          generated_by:    current_employee.employee_number,
          filters_applied: filters,
          **report
        })
      end

      private

      def filter_params
        params.permit(:start_date, :end_date, :department, :team_id, :format).to_h.symbolize_keys
      end

      def generate_report(code, filters)
        case code
        when "headcount"           then headcount_report(filters)
        when "leave_summary"       then leave_summary_report(filters)
        when "onboarding_status"   then onboarding_report(filters)
        when "team_roster"         then team_roster_report(filters)
        when "document_expiry"     then document_expiry_report(filters)
        when "qualification_matrix" then qualification_matrix_report(filters)
        when "task_completion"     then task_completion_report(filters)
        when "personal_summary"    then personal_summary_report
        end
      end

      def headcount_report(filters)
        scope = Employee.active
        scope = scope.by_department(filters[:department]) if filters[:department].present?

        totals  = scope.group(:department_lookup_id)
                       .joins(:department_lookup)
                       .select("lookup_values.value AS dept, COUNT(*) AS cnt")

        {
          summary: {
            total:      Employee.active.count,
            active:     Employee.active.where(is_onboarding_complete: true).count,
            onboarding: Employee.onboarding.count
          },
          rows: totals.map { |r| { department: r.dept, count: r.cnt } }
        }
      end

      def leave_summary_report(filters)
        year   = filters[:start_date]&.to_date&.year || Date.today.year
        scope  = EmployeeLeave.for_year(year)
        scope  = scope.joins(employee: :team_members).where(team_members: { team_id: current_employee.team_ids }) unless current_employee.has_permission?("leave.view_all")

        {
          summary: { year: year, total_requests: scope.count },
          rows:    scope.group(:status_lookup_id)
                        .joins(:status_lookup)
                        .select("lookup_values.value AS status, COUNT(*) AS cnt")
                        .map { |r| { status: r.status, count: r.cnt } }
        }
      end

      def onboarding_report(_filters)
        {
          summary: {
            completed:   Employee.active.where(is_onboarding_complete: true).count,
            in_progress: Employee.active.where(is_onboarding_complete: false).count
          },
          rows: Employee.onboarding.select(:id, :first_name, :last_name, :employee_number, :start_date).map do |e|
            { id: e.id, employee_number: e.employee_number, name: "#{e.first_name} #{e.last_name}", start_date: e.start_date }
          end
        }
      end

      def team_roster_report(filters)
        team   = filters[:team_id].present? ? Team.find(filters[:team_id]) : nil
        scope  = team ? TeamMember.where(team_id: team.id, is_active: true).includes(:employee) :
                        TeamMember.where(team_id: current_employee.team_ids, is_active: true).includes(:employee, :team)
        {
          summary: { total_members: scope.count },
          rows:    scope.map { |m| { team: m.team&.name, employee: m.employee&.full_name, role_title: m.role_title, joined_at: m.joined_at } }
        }
      end

      def document_expiry_report(_filters)
        docs = EmployeeDocument.kept.expiring_soon.includes(:employee, :document_type_lookup)
        {
          summary: { expiring_within_30_days: docs.count },
          rows:    docs.map { |d| { employee: d.employee&.full_name, title: d.title, expiry_date: d.expiry_date, type: d.document_type_lookup&.value } }
        }
      end

      def qualification_matrix_report(_filters)
        quals = EmployeeQualification.includes(:employee, :qualification_type_lookup).all
        {
          summary: { total: quals.count, verified: quals.where(is_verified: true).count },
          rows:    quals.map { |q| { employee: q.employee&.full_name, qualification: q.qualification_name, type: q.qualification_type_lookup&.value, is_verified: q.is_verified } }
        }
      end

      def task_completion_report(_filters)
        scope = current_employee.has_permission?("tasks.view_all") ? Task.kept : Task.kept.where(team_id: current_employee.team_ids)
        {
          summary: { total: scope.count, completed: scope.joins(:status_lookup).where(lookup_values: { code: "completed" }).count },
          rows:    scope.group(:status_lookup_id).joins(:status_lookup).select("lookup_values.value AS status, COUNT(*) AS cnt").map { |r| { status: r.status, count: r.cnt } }
        }
      end

      def personal_summary_report
        {
          summary: { employee_number: current_employee.employee_number, full_name: current_employee.full_name },
          rows: {
            leave_balances: current_employee.leave_balances.map { |b| { type: b.leave_type_lookup&.value, available: b.available_days, used: b.used_days } },
            tasks:          current_employee.tasks.kept.count,
            notifications:  current_employee.notifications.unread.count
          }
        }
      end
    end
  end
end
