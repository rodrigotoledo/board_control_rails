class TasksController < ApplicationController
  def index
    @tasks = Task.order(scheduled_at: :asc)
    render json: @tasks.all
  end

  def update
    @task = Task.find(params[:id])
    @task.update(completed: true, scheduled_at: Time.now)
    head :ok
  end
end
