class ProjectsController < ApplicationController
  def index
    set_projects
  end

  def update
    project = Project.find(params[:id])
    project.update(completed_at: Time.now)
    set_projects
  end

  protected

  def set_projects
    projects = Project.order(created_at: :asc)
    render json: projects.all
  end
end
