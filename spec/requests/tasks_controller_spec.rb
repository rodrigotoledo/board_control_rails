require 'rails_helper'

RSpec.describe 'TasksController', type: :request do
  let!(:user) { create(:user) }

  describe 'Tasks Operations' do
    before do
      @result = sign_in(user)
    end

    describe 'GET /tasks' do
      it 'returns a list of tasks in ascending order of creation' do
        create_list(:task, 5)
        get tasks_path, headers: { 'Authorization' => "Bearer #{@result['token']}" }
        tasks = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(tasks.length).to eq(5)
      end
    end

    describe 'PATCH /tasks/:id' do
      it 'marks a task as completed' do
        task = create(:task)

        patch task_path(task.id), headers: { 'Authorization' => "Bearer #{@result['token']}" }
        task.reload

        expect(response).to have_http_status(200)
        expect(task.completed_at).not_to be_nil
      end
    end
  end
end
