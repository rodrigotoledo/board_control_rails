# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project) }

  before do
    request.headers["Authorization"] = bearer_token(user)
  end

  describe "GET #index" do
    let(:scheduled_at) { 3.days.from_now }
    let!(:projects) do
      create_list(:project, 3)
      create(:project, scheduled_at: scheduled_at, completed_at: scheduled_at, name: "Final project")
    end

    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    context "searching terms and date" do
      it "returns a successful response with search term" do
        get :index, params: { q: { name_cont: "final pr" } }
        json_response = JSON.parse(response.body)
        expect(json_response["projects"].size).to eq(1)
      end

      it "returns a successful response with date" do
        get :index, params: { q: { scheduled_at_gteq: scheduled_at.to_date, scheduled_at_lteq: scheduled_at.to_date.end_of_day  } }
        json_response = JSON.parse(response.body)
        expect(json_response["projects"].size).to eq(1)
      end

      it "returns empty result with valid date but invalid term" do
        get :index, params: { q: { name_cont: 'wrong', scheduled_at_gteq: scheduled_at.to_date, scheduled_at_lteq: scheduled_at.to_date.end_of_day  } }
        json_response = JSON.parse(response.body)
        expect(json_response["projects"].size).to eq(0)
      end
    end

    it "returns paginated projects ordered by name" do
      get :index
      json_response = JSON.parse(response.body)

      expect(json_response["projects"].size).to eq(4)

      expect(json_response["meta"]).to include(
        "current_page" => 1,
        "total_pages" => 1,
        "total_count" => 4
      )
    end

    it "returns stats of projects" do
      get :stats
      json_response = JSON.parse(response.body)
      expect(json_response["total_count"]).to eq(4)
      expect(json_response["completed_count"]).to eq(1)
    end

    context "with pagination" do
      let!(:many_projects) { create_list(:project, 15, name: 3.days.from_now) }

      it "returns only the first page of projects" do
        get :index, params: { page: 1 }
        json_response = JSON.parse(response.body)

        expect(json_response["projects"].size).to be <= Kaminari.config.default_per_page
        expect(json_response["meta"]["current_page"]).to eq(1)
      end

      it "returns second page of projects" do
        get :index, params: { page: 2 }
        json_response = JSON.parse(response.body)

        expect(json_response["meta"]["current_page"]).to eq(2)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested project" do
        put :update, params: { id: project.id }
        project.reload
        expect(project.completed_at).to be_within(1.second).of(Time.now)
      end

      it "returns head :ok" do
        put :update, params: { id: project.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "returns not found for non-existent project" do
        put :update, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
