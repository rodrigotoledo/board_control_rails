module Completable
  extend ActiveSupport::Concern

  def completed_at!
    update!(completed_at: Time.current)
  end

  included do
    scope :completed, -> { where.not(completed_at: nil) }
  end
end
