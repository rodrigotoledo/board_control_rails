# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApplicationApiController
      before_action :authenticate_user!

      def index
        order_direction = params[:sort_direction] || :asc
        order_field = params[:sort_by] || :id

        safe_params = params.fetch(:q, {}).permit(
          :name_cont,
          :created_at_gteq,
          :created_at_lteq
        )

        q = Project.ransack(safe_params)
        projects = q.result
                    .page(params[:page])
                    .per(params[:per_page] || 10)
                    .order("#{order_field} #{order_direction || 'asc'}")

        render json: {
          projects: projects.as_json,
          meta: {
            current_page: projects.current_page,
            total_pages: projects.total_pages,
            total_count: projects.total_count
          }
        }
      end

      def stats
        render json: {
          total_count: Project.count,
          completed_count: Project.completed.count
        }
      end

      def update
        project = Project.find(params[:id])
        project.completed_at!
        head :ok
      rescue StandardError
        head :not_found
      end
    end
  end
end
