class TasksController < ApplicationController
  before_action :authenticate_user!
  def index
    tasks = Task.order(scheduled_at: :asc)
    render json: tasks.all
  end

  def update
    task = Task.find(params[:id])
    task.update(completed_at: Time.now)
    head :ok
  end
end
