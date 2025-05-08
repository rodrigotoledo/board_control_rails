# frozen_string_literal: true

module Api
  module V2
    class TasksController < ApplicationApiController
      before_action :authenticate_user!
      before_action :set_task, only: %i[show update mark_as_completed]
      before_action :set_completed_at, only: %i[index]

      def index
        tasks = Task.where("completed_at BETWEEN ? AND ?", @completed_at.beginning_of_day, @completed_at.end_of_day).order(:completed_at)

        render json: tasks.as_json
      end

      def show
        render json: @task.as_json
      end

      def update
        @task.update(task_params)
        head :ok
      rescue StandardError
        head :unprocessable_entity
      end

      def mark_as_completed
        @task.completed_at!
        head :ok
      end

      def stats
        render json: {
          total_count: Task.count,
          completed_count: Task.completed.count
        }
      end

      private

      def set_task
        @task = Task.find(params[:id])
      rescue StandardError
        head :not_found
      end

      def set_completed_at
        @completed_at = params[:completed_at].to_date
      rescue StandardError
        head :unprocessable_entity
      end

      def task_params
        params.require(:task).permit(:title, :completed_at)
      rescue StandardError
        head :unprocessable_entity
      end
    end
  end
end
