require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /index" do
    it "returns http move without authentication" do
      get "/home/index"
      expect(response).to have_http_status(404)
    end
  end
end
