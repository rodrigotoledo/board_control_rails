# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  describe "GET /new_registration" do
    it "returns http success" do
      get new_registration_path
      expect(response).to have_http_status(:ok)
    end
  end
end
