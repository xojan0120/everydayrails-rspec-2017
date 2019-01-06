require 'rails_helper'

RSpec.feature "Projects", type: :feature do

  let(:user) { FactoryBot.create(:user) }
  let!(:project) { FactoryBot.create(:project, name: "Test2 Project", description: "this is before", owner: user) }

  scenario "ユーザは新しいプロジェクトを作成する" do
    sign_in user
    visit root_path

    expect {
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  scenario "ユーザはプロジェクトを編集する" do
    sign_in user
    visit root_path

    click_link "Test2 Project"
    click_link "Edit"
    fill_in "Description", with: "this is after"
    click_button "Update Project"
    after_description = find("div.project-description").text

    expect(after_description).to eq "this is after"
  end

  scenario "ユーザはプロジェクトを完了済みにする" do
    # プロジェクトを持ったユーザを準備する
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user)
    # ユーザはログインしている
    sign_in user
    # ユーザがプロジェクト画面を開き、
    visit project_path(project)
    expect(page).to_not have_content("Completed")

    # "complete"ボタンをクリックすると、
    click_button "Complete"
    # プロジェクトは完了済みとしてマークされる
    expect(project.reload.completed?).to be true
    expect(page).to have_content "Congratulations, this project is complete!"
    expect(page).to have_content "Completed"

    # 完了ボタンは消えているか
    expect(page).to_not have_button("Complete")
  end

  scenario "完了済みのプロジェクトはユーザのダッシュボードに表示しない" do
    # 未完了と完了プロジェクトを持ったユーザを準備する
    user = FactoryBot.create(:user)
    incomplete_project = FactoryBot.create(:project,
                                            name: "未完了ぷろじぇくと",
                                            owner: user,
                                            completed: false)
    completed_project  = FactoryBot.create(:project,
                                            name: "完了済みぷろじぇくと",
                                            owner: user,
                                            completed: true)
    # ユーザはログインしている
    sign_in user
    # ユーザがプロジェクト画面を開く。
    visit project_path(project)
    # 未完了プロジェクトは表示されている。
    expect(page).to have_content("未完了ぷろじぇくと")
    # 完了プロジェクトは表示されていない。
    expect(page).to_not have_content("完了済みぷろじぇくと")
  end
end
