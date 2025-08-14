# frozen_string_literal: true

class AddScheduledAtToProjects < ActiveRecord::Migration[8.0]
  def change
    change_table :projects do |t|
      t.datetime :scheduled_at
    end
  end
end
