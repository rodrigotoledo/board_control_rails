require 'rails_helper'

RSpec.describe 'TasksController', type: :request do
  describe 'GET /tasks' do
    it 'returns a list of tasks in ascending order of creation' do
      # Crie alguns projetos usando Faker para testar
      5.times { create(:task) }

      get '/tasks'
      tasks = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(tasks.length).to eq(5)
      # Adicione mais expectativas conforme necessário
    end
  end

  describe 'PATCH /tasks/:id' do
    it 'marks a task as completed' do
      task = create(:task)

      patch "/tasks/#{task.id}"
      task.reload

      expect(response).to have_http_status(200)
      expect(task.completed_at).not_to be_nil
    end
  end
end
