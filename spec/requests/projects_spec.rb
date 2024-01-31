require 'rails_helper'

RSpec.describe 'ProjectsController', type: :request do
  describe 'GET /projects' do
    it 'returns a list of projects in ascending order of creation' do
      # Crie alguns projetos usando Faker para testar
      5.times { create(:project) }

      get '/projects'
      projects = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(projects.length).to eq(5)
      # Adicione mais expectativas conforme necessário
    end
  end

  describe 'PATCH /projects/:id' do
    it 'marks a project as completed' do
      project = create(:project)

      patch "/projects/#{project.id}"
      project.reload

      expect(response).to have_http_status(200)
      expect(project.completed_at).not_to be_nil
    end
  end
end
