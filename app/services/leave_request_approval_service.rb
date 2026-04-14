class LeaveRequestApprovalService < ApplicationService
  def initialize(leave:, reviewer:, decision:, comment: nil)
    @leave    = leave
    @reviewer = reviewer
    @decision = decision.to_sym   # :approve | :reject
    @comment  = comment
  end

  def call
    return failure("Leave request is not in pending state") unless @leave.pending?
    return failure("Cannot approve your own leave request") if self_approval?

    ActiveRecord::Base.transaction do
      update_leave_status!
      update_balance! if @decision == :approve
      notify_employee!
    end

    success(@leave)
  rescue ActiveRecord::RecordInvalid => e
    failure(e.message)
  end

  private

  def self_approval?
    @leave.employee_id == @reviewer.id
  end

  def update_leave_status!
    status_code = @decision == :approve ? "approved" : "rejected"
    status      = LookupType.values_for(:leave_status).find_by!(code: status_code)

    @leave.update!(
      status_lookup_id: status.id,
      reviewer:         @reviewer,
      reviewed_at:      Time.current,
      review_comment:   @comment
    )
  end

  def update_balance!
    balance = LeaveBalance.find_or_create_by!(
      employee_id:          @leave.employee_id,
      leave_type_lookup_id: @leave.leave_type_lookup_id,
      year:                 @leave.start_date.year
    ) do |b|
      b.total_days = 0
    end

    balance.increment!(:used_days,    @leave.days_requested)
    balance.decrement!(:pending_days, [@leave.days_requested, balance.pending_days].min)
  end

  def notify_employee!
    action = @decision == :approve ? "Approved" : "Rejected"
    NotificationService.send_to(
      employee:  @leave.employee,
      type_code: "leave",
      title:     "Leave Request #{action}",
      body:      @comment,
      resource:  @leave,
      url:       "/leave/#{@leave.id}"
    )
  end
end
