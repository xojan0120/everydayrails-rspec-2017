require 'rails_helper'

RSpec.describe "Projects", type: :request do
  context "認証済みのユーザーとして" do
    before do
      @user = FactoryBot.create(:user)
    end

    context "有効な属性値の場合" do
      it "プロジェクトを追加できること" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        expect {
          post projects_path, params: { project: project_params }
        }.to change(@user.projects, :count).by(1)
      end
    end

    context "無効な属性値の場合" do
      it "プロジェクトを追加できないこと" do
        project_params = FactoryBot.attributes_for(:project, :invalid)
        sign_in @user
        expect {
          post projects_path, params: { project: project_params }
        }.to_not change(@user.projects, :count)
      end
    end

    it "未完了のプロジェクトを取得できること" do
      FactoryBot.create(:project,
                         name: "未完了ぷろじぇくと",
                         owner: @user,
                         completed: false)
      FactoryBot.create(:project,
                         name: "完了済みぷろじぇくと",
                         owner: @user,
                         completed: true)
      sign_in @user
      get projects_path
      aggregate_failures {
        expect(response.body).to     include("未完了ぷろじぇくと")
        expect(response.body).to_not include("完了済みぷろじぇくと")
      }
    end

    it "未完了を含む全てのプロジェクトを取得できること" do
      FactoryBot.create(:project,
                         name: "未完了ぷろじぇくと",
                         owner: @user,
                         completed: false)
      FactoryBot.create(:project,
                         name: "完了済みぷろじぇくと",
                         owner: @user,
                         completed: true)
      sign_in @user
      get all_projects_path
      aggregate_failures {
        expect(response.body).to include("未完了ぷろじぇくと")
        expect(response.body).to include("完了済みぷろじぇくと")
      }
    end

  end
end
