# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V2::TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:completed_at) { "2001-01-01" }

  before do
    request.headers["Authorization"] = bearer_token(user)
  end

  describe "GET #index" do
    before do
      create_list(:task, 3, completed_at: completed_at.to_date)
      create(:task, completed_at: (completed_at.to_date - 1.day))
      create(:task)
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

    it "returns stats of tasks" do
      get :stats
      json_response = JSON.parse(response.body)
      expect(json_response["total_count"]).to eq(5)
      expect(json_response["completed_count"]).to eq(4)
    end
  end

  describe "GET #show" do
    context "with valid params" do
      let!(:task) { create(:task) }

      it "updates the requested task" do
        get :show, params: { id: task.id }
        json_response = JSON.parse(response.body)
        expect(task.id).to eql(json_response["id"])
      end
    end

    context "with invalid params" do
      it "returns not found for non-existent task" do
        get :show, params: { id: "fake" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PUT #mark_as_completed" do
    let!(:task) { create(:task) }

    context "with valid params" do
      it "updates with current time in completed_at" do
        put :mark_as_completed, params: { id: task.id }
        task.reload
        expect(response).to have_http_status(:ok)
        expect(task.completed_at).not_to be_nil
      end
    end
  end

  describe "PUT #update" do
    let!(:task) { create(:task) }

    context "with valid params" do
      let!(:new_info) { build(:task, completed_at: Time.now.change(usec: 0)) }

      it "updates the requested task" do
        put :update, params: { id: task.id, task: { title: new_info.title, completed_at: new_info.completed_at } }
        task.reload
        expect(task.title).to eql(new_info.title)
        expect(task.completed_at).to eql(new_info.completed_at)
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "returns not found for non-existent task" do
        put :update, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
      end

      it "returns unprocessable_entity without params task" do
        put :update, params: { id: task.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
