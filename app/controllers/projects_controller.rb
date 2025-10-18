# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]

  # GET /projects
  def index
    @projects = Project.order(updated_at: :desc)
  end

  # GET /projects/1
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    respond_to do |format|
      format.turbo_stream
    end
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    @project.save
    respond_to do |format|
      format.turbo_stream
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      respond_to do |format|
        format.turbo_stream
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy!
    redirect_to projects_path, notice: "Project was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.expect(project: [ :name, :users, :completed_at, :scheduled_at ])
    end
end
