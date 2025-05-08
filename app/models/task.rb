class Task < ApplicationRecord
  include Completable
  def self.ransackable_attributes(_auth_object = nil)
    %w[title scheduled_at]
  end
end
