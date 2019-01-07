require 'rails_helper'

RSpec.describe StatusOperation, type: :model do
  describe "プロジェクトステータス" do
    it "完了にする" do
      project = FactoryBot.create(:project)
      StatusOperation.complete(project)
      expect(project.completed).to be_truthy
    end
    it "未完了にする" do
      project = FactoryBot.create(:project, completed: true)
      StatusOperation.incomplete(project)
      expect(project.completed).to be_falsey
    end
  end
end
