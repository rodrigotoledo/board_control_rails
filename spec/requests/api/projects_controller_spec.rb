require 'rails_helper'

RSpec.describe 'ProjectsController', type: :request do
  let!(:user) { create(:user) }
  describe 'Projects Operations' do
    describe 'GET /projects' do
      it 'returns a list of projects in ascending order of creation' do
        create_list(:project, 5)

        get api_projects_path, headers: generate_jwt_token(user)
        projects = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(projects.length).to eq(5)
      end
    end

    describe 'PATCH /projects/:id' do
      it 'marks a project as completed' do
        project = create(:project)

        patch api_project_path(project.id), headers: generate_jwt_token(user)
        project.reload

        expect(response).to have_http_status(200)
        expect(project.completed_at).not_to be_nil
      end
    end
  end
end
