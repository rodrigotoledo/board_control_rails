# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /new_session" do
    it "returns http success" do
      get new_session_path
      expect(response).to have_http_status(:success)
    end
  end
end
