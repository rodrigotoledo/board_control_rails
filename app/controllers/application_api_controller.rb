# frozen_string_literal: true

class ApplicationApiController < ActionController::API
  include AuthenticationConcern
end
