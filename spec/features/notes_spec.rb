require 'rails_helper'

RSpec.feature "Notes", type: :feature do

  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, name: "RSpec tutorial", owner: user) }

  scenario "ユーザが添付ファイルをアップロードする" do
    sign_in user
    visit project_path(project)
    click_link "Add Note"
    fill_in "Message", with: "My book cover"
    attach_file "Attachment", "#{Rails.root}/spec/files/attachment.jpg"
  end
end
