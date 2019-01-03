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
end
