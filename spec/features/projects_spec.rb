require 'rails_helper'

RSpec.feature "Projects", type: :feature do

  let(:user) { FactoryBot.create(:user) }
  let!(:project) { FactoryBot.create(:project, 
                                      name: "Test2 Project",
                                      description:
                                      "this is before",
                                      owner: user) }

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
    # 未完了プロジェクトを持ったユーザを準備する
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user, completed: false)
    # ユーザはログインしている
    sign_in user
    # ユーザがプロジェクト画面を開く。
    visit project_path(project)
    # 完了ボタンがある。
    expect(page).to have_button("Complete")

    # 完了ボタンをクリックすると、
    click_button "Complete"
    # プロジェクトは完了済みとしてマークされる
    expect(project.reload.completed?).to be_truthy
    expect(page).to have_content "Congratulations, this project is complete!"

    # 完了ボタンが無くなり、未完了ボタンがある。
    expect(page).to_not have_button "Complete"
    expect(page).to     have_button "Incomplete"
  end

  scenario "ユーザはプロジェクトを未完了にする" do
    # 完了済みプロジェクトを持ったユーザを準備する
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user, completed: true)
    # ユーザはログインしている
    sign_in user
    # ユーザがプロジェクト画面を開く。
    visit project_path(project)
    # 未完了ボタンがある。
    expect(page).to have_button("Incomplete")

    # 未完了ボタンをクリックすると、
    click_button "Incomplete"
    # プロジェクトは未完了としてマークされる
    expect(project.reload.completed?).to be false
    expect(page).to have_content "Congratulations, this project is incomplete!"

    # 未完了ボタンが無くなり、完了ボタンがある。
    expect(page).to_not have_button "Incomplete"
    expect(page).to     have_button "Complete"
  end

  scenario "ユーザがプロジェクトの完了処理に失敗すると失敗のメッセージを表示する" do
    # 未完了プロジェクトを持ったユーザを準備する
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user, completed: false)
    # ユーザはログインしている
    sign_in user
    # ユーザがプロジェクト画面を開く。
    visit project_path(project)
    # 完了ボタンがある。
    expect(page).to have_button("Complete")
    # Projectインスタンスのcompleteメソッドをスタブ化して必ずfalseが返るようにする。
    allow_any_instance_of(Project).to receive(:complete).and_return(false)
    # 完了ボタンをクリックする。
    click_button "Complete"
    # 完了処理失敗のメッセージが表示される。
    expect(page).to have_content "Unable to complete project."
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
    # ユーザがダッシュボード画面を開く。
    visit projects_path

    aggregate_failures {
      # 未完了プロジェクトは表示されている。
      expect(page).to have_content(incomplete_project.name)
      # 完了プロジェクトは表示されていない。
      expect(page).to_not have_content(completed_project.name)
    }
  end

  scenario "ユーザのダッシュボードで、未完了のプロジェクト表示と全てのプロジェクト表示を切り替える" do
    # 未完了と完了プロジェクトをそれぞれ2個以上持ったユーザを準備する
    user = FactoryBot.create(:user)
    incomplete_project1 = FactoryBot.create(:project,
                                            name: "未完了ぷろじぇくと1",
                                            owner: user,
                                            completed: false)
    incomplete_project2 = FactoryBot.create(:project,
                                            name: "未完了ぷろじぇくと2",
                                            owner: user,
                                            completed: false)
    completed_project1  = FactoryBot.create(:project,
                                            name: "完了済みぷろじぇくと1",
                                            owner: user,
                                            completed: true)
    completed_project2  = FactoryBot.create(:project,
                                            name: "完了済みぷろじぇくと2",
                                            owner: user,
                                            completed: true)
    # ユーザはログインしている。
    sign_in user
    # ユーザがダッシュボード画面を開く。
    visit projects_path
    # 全て表示のボタンがある。
    expect(page).to have_link("Display All")
    # 未完了プロジェクトのみ表示されている。
    aggregate_failures {
      expect(page).to     have_content(incomplete_project1.name)
      expect(page).to     have_content(incomplete_project2.name)
      expect(page).to_not have_content(completed_project1.name)
      expect(page).to_not have_content(completed_project2.name)
    }
    # 全て表示のボタンをクリックする。
    click_link "Display All"
    # 全て表示のボタンが無くなり、未完了のみ表示のボタンがある。
    expect(page).to_not have_link("Display All")
    expect(page).to     have_link("Only Incomplete")
    # 全てのプロジェクトが表示されている。
    aggregate_failures {
      expect(page).to have_content(incomplete_project1.name)
      expect(page).to have_content(incomplete_project2.name)
      expect(page).to have_content(completed_project1.name)
      expect(page).to have_content(completed_project2.name)
    }
    # 完了済みのプロジェクトのclass属性がdelになっている。
    aggregate_failures {
      expect(find_link(incomplete_project1.name)[:class]).to_not eq "del"
      expect(find_link(incomplete_project2.name)[:class]).to_not eq "del"
      expect(find_link(completed_project1.name)[:class]).to eq "del"
      expect(find_link(completed_project2.name)[:class]).to eq "del"
    }
    # 未完了のみ表示のボタンをクリックする。
    click_link "Only Incomplete"
    # 未完了プロジェクトのみ表示されている。
    aggregate_failures {
      expect(page).to     have_content(incomplete_project1.name)
      expect(page).to     have_content(incomplete_project2.name)
      expect(page).to_not have_content(completed_project1.name)
      expect(page).to_not have_content(completed_project2.name)
    }
  end
end
