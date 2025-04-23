require 'rails_helper'

RSpec.describe "PracticeLogs", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/practice_log/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/practice_log/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/practice_log/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/practice_log/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/practice_log/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
