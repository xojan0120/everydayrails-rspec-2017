require 'rails_helper'

RSpec.feature "Tasks", type: :feature do

  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, name: "RSpec tutorial", owner: user) }
  let!(:task) { project.tasks.create!(name: "Finish RSpec tutorial") }
  let!(:task1) { project.tasks.create!(name: "Finish RSpec tutorial1") }
  let!(:task2) { project.tasks.create!(name: "Finish RSpec tutorial2") }

  scenario "ユーザがタスクの状態を切り替える", js: true do
    sign_in user
    go_to_project "RSpec tutorial"

    complete_task "Finish RSpec tutorial"
    expect_complete_task "Finish RSpec tutorial"

    undo_complete_task "Finish RSpec tutorial"
    expect_incomplete_task "Finish RSpec tutorial"
  end

  def go_to_project(name)
    visit root_path
    click_link name
  end

  def complete_task(name)
    check name
  end

  def undo_complete_task(name)
    uncheck name
  end

  def expect_complete_task(name)
    aggregate_failures do
      expect(page).to have_css "label.completed", text: name
      expect(task.reload).to be_completed
    end
  end

  def expect_incomplete_task(name)
    aggregate_failures do
      expect(page).to_not have_css "label.completed", text: name
      expect(task.reload).to_not be_completed
    end
  end

  scenario "ユーザがタスクの削除する" do
    sign_in user
    go_to_project "RSpec tutorial"

    delete_link1 = find_link_by_href("/projects/#{project.id}/tasks/#{task1.id}")
    delete_link1.click
    expect(page).to_not have_css "label#task_#{task1.id}"

    delete_link2 = find_link_by_href("/projects/#{project.id}/tasks/#{task2.id}")
    delete_link2.click
    expect(page).to_not have_css "label#task_#{task2.id}"
  end

  def find_link_by_href(href)
    page.find(%Q(a[href="#{href}"]))
  end
end
