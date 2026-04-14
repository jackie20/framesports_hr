module Api
  module V1
    class LeaveController < ApplicationController
      before_action :set_leave, only: [:show, :destroy, :approve, :reject]

      # GET /api/v1/leave/balance
      def balance
        require_permission!("leave.view_own")
        balances = current_employee.leave_balances.includes(:leave_type_lookup)
        render_success(balances.map { |b| LeaveBalanceSerializer.new(b).serializable_hash[:data] })
      end

      # GET /api/v1/leave/team_calendar
      def team_calendar
        require_permission!("leave.view_team")
        team_ids = current_employee.team_ids
        leaves = EmployeeLeave.approved
                              .joins(employee: :team_members)
                              .where(team_members: { team_id: team_ids, is_active: true })
                              .where("start_date >= ?", params.fetch(:start_date, Date.today.beginning_of_month))
                              .where("end_date <= ?",   params.fetch(:end_date,   Date.today.end_of_month))
                              .includes(:employee, :leave_type_lookup)
                              .distinct
        render_success(leaves.map { |l| LeaveSerializer.new(l).serializable_hash[:data] })
      end

      # GET /api/v1/leave
      def index
        if current_employee.has_permission?("leave.view_all")
          leaves = EmployeeLeave.all
        elsif current_employee.has_permission?("leave.view_team")
          team_ids = current_employee.team_ids
          leaves = EmployeeLeave.joins(employee: :team_members)
                                .where(team_members: { team_id: team_ids, is_active: true })
        else
          require_permission!("leave.view_own")
          leaves = current_employee.employee_leaves
        end

        leaves = paginate(leaves.includes(:employee, :leave_type_lookup, :status_lookup).order(created_at: :desc))
        render_collection(leaves.map { |l| LeaveSerializer.new(l).serializable_hash[:data] })
      end

      # GET /api/v1/leave/:id
      def show
        require_permission!("leave.view_own", "leave.view_all")
        unless can_view_leave?
          return render json: error_response("Forbidden", "Access denied", status: 403), status: :forbidden
        end
        render_success(LeaveSerializer.new(@leave).serializable_hash[:data])
      end

      # POST /api/v1/leave
      def create
        require_permission!("leave.request")
        status = LookupType.values_for(:leave_status).find_by!(code: "pending")

        leave = current_employee.employee_leaves.build(
          leave_params.merge(status_lookup_id: status.id)
        )

        if leave.save
          pending_balance_adjustment!(leave)
          render_created(LeaveSerializer.new(leave).serializable_hash[:data])
        else
          render_record_errors(leave)
        end
      end

      # DELETE /api/v1/leave/:id
      def destroy
        require_permission!("leave.request")
        unless @leave.employee_id == current_employee.id && @leave.pending?
          return render json: error_response("Forbidden", "Cannot cancel this leave request", status: 403), status: :forbidden
        end

        cancelled_status = LookupType.values_for(:leave_status).find_by!(code: "cancelled")
        @leave.update!(status_lookup_id: cancelled_status.id)
        render_no_content
      end

      # PUT /api/v1/leave/:id/approve
      def approve
        require_permission!("leave.approve")
        result = LeaveRequestApprovalService.call(
          leave: @leave, reviewer: current_employee,
          decision: :approve, comment: params[:comment]
        )
        handle_approval_result(result)
      end

      # PUT /api/v1/leave/:id/reject
      def reject
        require_permission!("leave.approve")
        result = LeaveRequestApprovalService.call(
          leave: @leave, reviewer: current_employee,
          decision: :reject, comment: params[:comment]
        )
        handle_approval_result(result)
      end

      private

      def set_leave
        @leave = EmployeeLeave.find(params[:id])
      end

      def leave_params
        params.require(:employee_leave).permit(
          :leave_type_lookup_id, :start_date, :end_date, :days_requested, :reason
        )
      end

      def can_view_leave?
        @leave.employee_id == current_employee.id ||
          current_employee.has_permission?("leave.view_all") ||
          (current_employee.has_permission?("leave.view_team") &&
            current_employee.team_ids.intersect?(@leave.employee.team_ids))
      end

      def pending_balance_adjustment!(leave)
        balance = LeaveBalance.find_by(
          employee_id:          leave.employee_id,
          leave_type_lookup_id: leave.leave_type_lookup_id,
          year:                 leave.start_date.year
        )
        balance&.increment!(:pending_days, leave.days_requested)
      end

      def handle_approval_result(result)
        if result.success?
          render_success(LeaveSerializer.new(result.data).serializable_hash[:data])
        else
          render json: error_response("Unprocessable Entity", result.error, status: 422), status: :unprocessable_entity
        end
      end
    end
  end
end
