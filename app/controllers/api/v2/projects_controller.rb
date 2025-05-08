# frozen_string_literal: true

module Api
  module V2
    class ProjectsController < ApplicationApiController
      before_action :authenticate_user!
      before_action :set_project, only: %i[show update mark_as_completed]
      before_action :set_completed_at, only: %i[index]

      def index
        projects = Project.where("completed_at BETWEEN ? AND ?", @completed_at.beginning_of_day, @completed_at.end_of_day).order(:completed_at)

        render json: projects.as_json
      end

      def show
        render json: @project.as_json
      end

      def update
        @project.update(project_params)
        head :ok
      rescue StandardError
        head :unprocessable_entity
      end

      def mark_as_completed
        @project.completed_at!
        head :ok
      end

      def stats
        render json: {
          total_count: Project.count,
          completed_count: Project.completed.count
        }
      end

      private

      def set_project
        @project = Project.find(params[:id])
      rescue StandardError
        head :not_found
      end

      def set_completed_at
        @completed_at = params[:completed_at].to_date
      rescue StandardError
        head :unprocessable_entity
      end

      def project_params
        params.require(:project).permit(:name, :completed_at, :users)
      rescue StandardError
        head :unprocessable_entity
      end
    end
  end
end
