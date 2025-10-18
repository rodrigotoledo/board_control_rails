# frozen_string_literal: true

class Project < ApplicationRecord
  include Completable
  def self.ransackable_attributes(_auth_object = nil)
    %w[name scheduled_at]
  end
  validates :name, presence: true

  after_create_commit do
    broadcast_prepend_to "projects", target: "projects", partial: "projects/project", locals: { project: self }
    broadcast_update_to "total_of_projects", target: "total_of_projects", partial: "projects/total_of_projects"
  end
  after_update_commit do
    broadcast_replace_to "projects", target: "project_#{id}", partial: "projects/project", locals: { project: self }
    broadcast_update_to "total_of_projects", target: "total_of_projects", partial: "projects/total_of_projects"
  end
  after_destroy_commit do
    broadcast_remove_to "projects", target: "project_#{id}"
    broadcast_update_to "total_of_projects", target: "total_of_projects", partial: "projects/total_of_projects"
  end
end
