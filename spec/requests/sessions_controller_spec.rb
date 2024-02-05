require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let!(:user) { create(:user) }

  describe 'POST /sign_in' do
    context 'with valid credentials' do
      it 'logs in the user' do
        post sign_in_path, params: {email: user.email, password: PASSWORD_FOR_USER}
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('user')
        expect(json_response).to have_key('token')
      end

      it 'decode token with invalid request' do
        sign_in(create(:user))
        get tasks_path, headers: { 'Authorization' => "123" }
      end
    end

    context 'with invalid credentials' do
      it 'returns unprocessable entity' do
        post sign_in_path, params: {email: user.email, password: '123'}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /logout' do
    before do
      sign_in user
    end
    it 'logout the user' do
      delete logout_path
      expect(response).to have_http_status(:no_content)
    end
  end
end
