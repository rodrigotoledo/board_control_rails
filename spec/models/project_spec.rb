# spec/models/project_spec.rb
require "rails_helper"

RSpec.describe Project, type: :model do
  describe "scopes" do
    describe ".completed" do
      let!(:completed_project) { create(:project, completed_at: Time.current) }
      let!(:incomplete_project) { create(:project, completed_at: nil) }

      it "returns only completed projects" do
        expect(Project.completed).to include(completed_project)
        expect(Project.completed).not_to include(incomplete_project)
      end

      it "uses SQL NOT NULL condition" do
        query = Project.completed.to_sql
        expect(query).to include("IS NOT NULL")
      end
    end
  end

  describe "fill with current time in completed_at" do
    let!(:incomplete_project) { create(:project, completed_at: nil) }

    it "#completed_at!" do
      expect(incomplete_project.completed_at!).to be_truthy
    end
  end
end
