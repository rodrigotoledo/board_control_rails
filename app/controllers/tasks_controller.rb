class TasksController < ApplicationController
  def index
    set_tasks
  end

  def update
    task = Task.find(params[:id])
    task.update(completed_at: Time.now)
    set_tasks
  end

  protected

  def set_tasks
    tasks = Task.order(scheduled_at: :asc)
    render json: tasks.all
  end
end
