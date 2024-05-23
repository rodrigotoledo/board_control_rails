# frozen_string_literal: true

module Api
  class RegistrationsController < ApplicationController
    def create
      user = User.new(user_params)
      if user.save
        token = login(user)
        render json: { user: user.attributes.except('password_digest'), token: token }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
