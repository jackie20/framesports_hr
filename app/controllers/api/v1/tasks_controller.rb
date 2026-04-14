module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [:show, :update, :destroy]

      # GET /api/v1/tasks
      def index
        tasks = scoped_tasks
        tasks = paginate(tasks.includes(:creator, :assignee, :status_lookup, :priority_lookup).order(created_at: :desc))
        render_collection(tasks.map { |t| TaskSerializer.new(t).serializable_hash[:data] })
      end

      # GET /api/v1/tasks/:id
      def show
        require_permission!("tasks.view_own", "tasks.view_all")
        render_success(TaskSerializer.new(@task, include: [:comments]).serializable_hash[:data])
      end

      # POST /api/v1/tasks
      def create
        require_permission!("tasks.create")
        status   = LookupType.values_for(:task_status).find_by!(code: "open")
        priority = LookupType.values_for(:task_priority).find_by!(code: params.dig(:task, :priority_code) || "medium")

        task = Task.new(
          task_params.merge(
            creator_id:        current_employee.id,
            status_lookup_id:  status.id,
            priority_lookup_id: priority.id
          )
        )
        if task.save
          render_created(TaskSerializer.new(task).serializable_hash[:data])
        else
          render_record_errors(task)
        end
      end

      # PUT /api/v1/tasks/:id
      def update
        require_permission!("tasks.update_own", "tasks.manage")
        unless can_update_task?
          return render json: error_response("Forbidden", "You cannot update this task", status: 403), status: :forbidden
        end

        if @task.update(task_update_params)
          render_success(TaskSerializer.new(@task).serializable_hash[:data])
        else
          render_record_errors(@task)
        end
      end

      # DELETE /api/v1/tasks/:id
      def destroy
        require_permission!("tasks.manage")
        @task.discard
        render_no_content
      end

      private

      def set_task
        @task = Task.kept.find(params[:id])
      end

      def scoped_tasks
        if current_employee.has_permission?("tasks.view_all")
          Task.kept
        elsif current_employee.has_permission?("tasks.view_team")
          Task.kept.where(team_id: current_employee.team_ids)
                   .or(Task.kept.where(assignee_id: current_employee.id))
        else
          require_permission!("tasks.view_own")
          Task.kept.where(assignee_id: current_employee.id)
                   .or(Task.kept.where(creator_id: current_employee.id))
        end
      end

      def task_params
        params.require(:task).permit(
          :title, :description, :assignee_id, :team_id, :due_date, :parent_task_id
        )
      end

      def task_update_params
        base = params.require(:task).permit(:title, :description, :assignee_id, :due_date, :completed_at)
        if params.dig(:task, :status_code).present?
          status = LookupType.values_for(:task_status).find_by!(code: params.dig(:task, :status_code))
          base[:status_lookup_id] = status.id
          base[:completed_at]     = Time.current if params.dig(:task, :status_code) == "completed"
        end
        base
      end

      def can_update_task?
        current_employee.has_permission?("tasks.manage") ||
          (@task.assignee_id == current_employee.id && current_employee.has_permission?("tasks.update_own"))
      end
    end
  end
end
