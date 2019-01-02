require 'rails_helper'

RSpec.describe Project, type: :model do

  before do
    #@user = User.create(
    #  first_name:     "Joe",
    #  last_name:      "Tester",
    #  email:          "joetester@example.com",
    #  password:       "dottle-nouveau-pavilion-tights-furze",
    #)
    @user = FactoryBot.create(:user,
                                first_name:  "Joe",
                                last_name:   "Tester",
                                email:       "joetester@example.com"
                             )

    #@other_user = User.create(
    #  first_name:     "Jane",
    #  last_name:      "Tester",
    #  email:          "janetester@example.com",
    #  password:       "dottle-nouveau-pavilion-tights-furze",
    #)
    @other_user = FactoryBot.create(:user,
                                      first_name:  "Jane",
                                      last_name:   "Tester",
                                      email:       "janetester@example.com"
                                   )

    @project_name = "Test Project"
  end

  it "プロジェクト名がなければ無効であること" do
    project = @user.projects.build(name: nil)
    expect(project).to_not be_valid
  end

  it "ユーザー単位では重複したプロジェクト名を許可しないこと" do
    @user.projects.create(name: @project_name)

    new_project = @user.projects.build(name: @project_name)

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  it "二人のユーザーが同じプロジェクト名を使うことは許可すること" do
    @user.projects.create(name: @project_name)

    other_project = @other_user.projects.build(name: @project_name)

    expect(other_project).to be_valid
  end

  describe "遅延ステータス" do
    it "締切日が過ぎていれば遅延していること" do
      project = FactoryBot.create(:project_due_yesterday)
      expect(project).to be_late
    end

    it "締切日が今日ならスケジュールどおりであること" do
      project = FactoryBot.create(:project_due_today)
      expect(project).to_not be_late
    end

    it "締切日が未来ならスケジュールどおりであること" do
      project = FactoryBot.create(:project_due_tomorrow)
      expect(project).to_not be_late
    end

  end

  it "５つのメモが付いていること" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end
end
