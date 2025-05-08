# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V2::ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let(:completed_at) { "2001-01-01" }

  before do
    request.headers["Authorization"] = bearer_token(user)
  end

  describe "GET #index" do
    before do
      create_list(:project, 3, completed_at: completed_at.to_date)
      create(:project, completed_at: (completed_at.to_date - 1.day))
      create(:project)
    end

    it "returns not found for completed_at parameter" do
      get :index
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns a successful response" do
      get :index, params: { completed_at: completed_at }
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(3)
      expect(response).to be_successful
    end

    it "returns stats of projects" do
      get :stats
      json_response = JSON.parse(response.body)
      expect(json_response["total_count"]).to eq(5)
      expect(json_response["completed_count"]).to eq(4)
    end
  end

  describe "GET #show" do
    context "with valid params" do
      let!(:project) { create(:project) }

      it "updates the requested project" do
        get :show, params: { id: project.id }
        json_response = JSON.parse(response.body)
        expect(project.id).to eql(json_response["id"])
      end
    end

    context "with invalid params" do
      it "returns not found for non-existent project" do
        get :show, params: { id: "fake" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PUT #mark_as_completed" do
    let!(:project) { create(:project) }

    context "with valid params" do
      it "updates with current time in completed_at" do
        put :mark_as_completed, params: { id: project.id }
        project.reload
        expect(response).to have_http_status(:ok)
        expect(project.completed_at).not_to be_nil
      end
    end
  end

  describe "PUT #update" do
    let!(:project) { create(:project) }

    context "with valid params" do
      let!(:new_info) { build(:project, completed_at: Time.now.change(usec: 0)) }

      it "updates the requested project" do
        put :update, params: { id: project.id, project: { name: new_info.name, completed_at: new_info.completed_at, users: new_info.users } }
        project.reload
        expect(project.name).to eql(new_info.name)
        expect(project.completed_at).to eql(new_info.completed_at)
        expect(project.users).to eql(new_info.users)
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "returns not found for non-existent project" do
        put :update, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
      end

      it "returns unprocessable_entity without params project" do
        put :update, params: { id: project.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
