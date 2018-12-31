require 'rails_helper'

RSpec.describe Project, type: :model do

  before do
    @user = User.create(
      first_name:     "Joe",
      last_name:      "Tester",
      email:          "joetester@example.com",
      password:       "dottle-nouveau-pavilion-tights-furze",
    )

    @other_user = User.create(
      first_name:     "Jane",
      last_name:      "Tester",
      email:          "janetester@example.com",
      password:       "dottle-nouveau-pavilion-tights-furze",
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

  it "二人のユーザーが同じ名前を使うことは許可すること" do
    @user.projects.create(name: @project_name)

    other_project = @other_user.projects.build(name: @project_name)

    expect(other_project).to be_valid
  end
end
