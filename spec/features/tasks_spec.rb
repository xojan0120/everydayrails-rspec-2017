require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  scenario "ユーザがタスクの状態を切り替える", js: true do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, name: "RSpec tutorial", owner: user)
    task = project.tasks.create!(name: "Finish RSpec tutorial")

    visit root_path

    click_link "Sign in"
    fill_in "Email", with: user.email

    fill_in "Password", with: user.password
    click_button "Log in"

    click_link "RSpec tutorial"

    check "Finish RSpec tutorial"

    expect(page).to have_css "label#task_#{task.id}.completed"
    expect(task.reload).to be_completed

    uncheck "Finish RSpec tutorial"

    expect(page).to_not have_css "label#task_#{task.id}.completed"
    expect(task.reload).to_not be_completed
  end

  scenario "ユーザがタスクの削除する" do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, name: "RSpec tutorial", owner: user)
    task1 = project.tasks.create!(name: "Finish RSpec tutorial1")
    task2 = project.tasks.create!(name: "Finish RSpec tutorial2")

    visit root_path

    click_link "Sign in"
    fill_in "Email", with: user.email

    fill_in "Password", with: user.password
    click_button "Log in"

    click_link "RSpec tutorial"

    expect(page).to have_css "label#task_#{task1.id}"
    expect(page).to have_css "label#task_#{task2.id}"

    delete_link1 = page.find(%Q(a[href="/projects/#{project.id}/tasks/#{task1.id}"]))
    delete_link2 = page.find(%Q(a[href="/projects/#{project.id}/tasks/#{task2.id}"]))

    delete_link1.click
    expect(page).to_not have_css "label#task_#{task1.id}"

    delete_link2.click
    expect(page).to_not have_css "label#task_#{task2.id}"
  end
end
