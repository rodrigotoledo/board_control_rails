# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:task) { create(:task) }

  before do
    request.headers["Authorization"] = bearer_token(user)
  end

  describe "GET #index" do
    let(:scheduled_at) { 3.days.from_now }
    let!(:tasks) do
      create_list(:task, 3).tap do |tasks|
        tasks[0].update(scheduled_at: 1.day.ago, title: "My Task")
        tasks[1].update(scheduled_at: 1.day.from_now)
        tasks[2].update(scheduled_at: scheduled_at, title: 'Final task', completed_at: scheduled_at)
      end
    end

    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    context "searching terms and date" do
      it "returns a successful response with search term" do
        get :index, params: { q: { title_cont: "my ta" } }
        json_response = JSON.parse(response.body)
        expect(json_response["tasks"].size).to eq(1)
      end

      it "returns a successful response with date" do
        get :index, params: { q: { scheduled_at_gteq: scheduled_at.to_date, scheduled_at_lteq: scheduled_at.to_date.end_of_day  } }
        json_response = JSON.parse(response.body)
        expect(json_response["tasks"].size).to eq(1)
      end

      it "returns empty result with valid date but invalid term" do
        get :index, params: { q: { title_cont: 'wrong', scheduled_at_gteq: scheduled_at.to_date, scheduled_at_lteq: scheduled_at.to_date.end_of_day  } }
        json_response = JSON.parse(response.body)
        expect(json_response["tasks"].size).to eq(0)
      end
    end

    it "returns paginated tasks ordered by scheduled_at" do
      get :index
      json_response = JSON.parse(response.body)

      expect(json_response["tasks"].size).to eq(3)
      expect(json_response["tasks"].first["id"]).to eq(tasks[0].id)

      expect(json_response["meta"]).to include(
        "current_page" => 1,
        "total_pages" => 1,
        "total_count" => 3
      )
    end

    it "returns stats of task" do
      get :stats
      json_response = JSON.parse(response.body)
      expect(json_response["total_count"]).to eq(3)
      expect(json_response["completed_count"]).to eq(1)
    end

    context "with pagination" do
      let!(:many_tasks) { create_list(:task, 15, scheduled_at: 3.days.from_now) }

      it "returns only the first page of tasks" do
        get :index, params: { page: 1 }
        json_response = JSON.parse(response.body)

        expect(json_response["tasks"].size).to be <= Kaminari.config.default_per_page
        expect(json_response["meta"]["current_page"]).to eq(1)
      end

      it "returns second page of tasks" do
        get :index, params: { page: 2 }
        json_response = JSON.parse(response.body)

        expect(json_response["meta"]["current_page"]).to eq(2)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested task" do
        put :update, params: { id: task.id }
        task.reload
        expect(task.completed_at).to be_within(1.second).of(Time.now)
      end

      it "returns head :ok" do
        put :update, params: { id: task.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "returns not found for non-existent task" do
        put :update, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
