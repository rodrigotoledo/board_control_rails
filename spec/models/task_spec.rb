# spec/models/task_spec.rb
require "rails_helper"

RSpec.describe Task, type: :model do
  describe "scopes" do
    describe ".completed" do
      let!(:completed_task) { create(:task, completed_at: Time.current) }
      let!(:incomplete_task) { create(:task, completed_at: nil) }

      it "returns only completed tasks" do
        expect(Task.completed).to include(completed_task)
        expect(Task.completed).not_to include(incomplete_task)
      end

      it "uses SQL NOT NULL condition" do
        query = Task.completed.to_sql
        expect(query).to include("IS NOT NULL")
      end
    end
  end

  describe "fill with current time in completed_at" do
    let!(:incomplete_task) { create(:task, completed_at: nil) }

    it "#completed_at!" do
      expect(incomplete_task.completed_at!).to be_truthy
    end
  end
end
