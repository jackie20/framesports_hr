module Api
  module V1
    class TaskCommentsController < ApplicationController
      before_action :set_task

      def index
        render_success(@task.task_comments.kept.includes(:author).order(created_at: :asc)
                            .map { |c| TaskCommentSerializer.new(c).serializable_hash[:data] })
      end

      def create
        require_permission!("tasks.view_own", "tasks.view_all")
        comment = @task.task_comments.build(body: params[:body], author: current_employee)
        if comment.save
          render_created(TaskCommentSerializer.new(comment).serializable_hash[:data])
        else
          render_record_errors(comment)
        end
      end

      def destroy
        comment = @task.task_comments.kept.find(params[:id])
        unless comment.author_id == current_employee.id || current_employee.has_permission?("tasks.manage")
          return render json: error_response("Forbidden", "Access denied", status: 403), status: :forbidden
        end
        comment.discard
        render_no_content
      end

      private

      def set_task
        @task = Task.kept.find(params[:task_id])
      end
    end
  end
end
