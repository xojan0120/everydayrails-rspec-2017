require 'rails_helper'

RSpec.feature "PasswordResets", type: :feature do
  include ActiveJob::TestHelper

  let!(:user) { FactoryBot.create(:user, email:"reset_test@example.com") }

  scenario "ユーザーはパスワードリセットができる" do

    visit root_path
    click_link "Sign in"
    click_link "Forgot your password?"

    perform_enqueued_jobs do
      fill_in "Email", with: "reset_test@example.com"
      click_button "Send me reset password instructions"

      expect(page).to have_content "You will receive an email with instructions on how to reset your password in a few minutes."
    end

    mail = ActionMailer::Base.deliveries.last

    # aggregate_failuresはブロック内のエクスペクテーションを失敗の有無
    # に関わらず全て実行してくれる
    aggregate_failures do
      expect(mail.to).to eq ["reset_test@example.com"]
      expect(mail.from).to eq ["please-change-me-at-config-initializers-devise@example.com"]
      expect(mail.subject).to eq "Reset password instructions"
    end
  end
end
