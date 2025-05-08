# frozen_string_literal: true

module Api
  module V1
    class TasksController < ApplicationApiController
      before_action :authenticate_user!

      def index
        order_direction = params[:sort_direction] || :asc
        order_field = params[:sort_by] || :scheduled_at

        safe_params = params.fetch(:q, {}).permit(
          :title_cont,
          :scheduled_at_gteq,
          :scheduled_at_lteq
        )

        q = Task.ransack(safe_params)
        tasks = q.result
                 .page(params[:page])
                 .per(params[:per_page] || 10)
                 .order("#{order_field} #{order_direction || 'asc'}")

        render json: {
          tasks: tasks.as_json,
          meta: {
            current_page: tasks.current_page,
            total_pages: tasks.total_pages,
            total_count: tasks.total_count
          }
        }
      end

      def stats
        render json: {
          total_count: Task.count,
          completed_count: Task.completed.count
        }
      end

      def update
        task = Task.find(params[:id])
        task.completed_at!
        head :ok
      rescue StandardError
        head :not_found
      end
    end
  end
end
