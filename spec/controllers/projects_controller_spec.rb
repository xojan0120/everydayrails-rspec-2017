require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "#index" do
    context "認証済みのユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
      end

      it "正常にレスポンスを返すこと" do
        # sign_inはdeviseによって提供されているメソッド。
        # このメソッドをRSpecテストで使用できるようにするためには、
        # spec/rails_helper.rbに下記の1文を追加する必要がある。
        # → config.include Devise::Test::ControllerHelpers, type: :controller
        sign_in @user
        get :index
        expect(response).to be_success
      end

      it "200レスポンスを返すこと" do
        sign_in @user
        get :index
        expect(response).to have_http_status "200"
      end
    end

    context "ゲストとして" do
      it "302レスポンスを返すこと" do
        get :index
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#show" do
    context "認可されたユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "正常にレスポンスを返すこと" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to be_success
      end
    end

    context "認可されていないユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it "ダッシュボードへリダイレクトすること" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#create" do
    context "認証済みのユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
      end

      context "有効な属性値の場合" do
        it "プロジェクトを追加できること" do
          # Projectモデルの属性をハッシュで取得
          project_params = FactoryBot.attributes_for(:project)
          sign_in @user
          expect {
            post :create, params: { project: project_params }
          }.to change(@user.projects, :count).by(1)
        end
      end

      context "無効な属性値の場合" do
        it "プロジェクトを追加できないこと" do
          project_params = FactoryBot.attributes_for(:project, name: nil)
          sign_in @user
          expect {
            post :create, params: { project: project_params }
          }.to_not change(@user.projects, :count)
        end
      end
    end

    context "ゲストとして" do
      it "302レスポンスを返すこと" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#update" do
    context "認可されたユーザとして" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "プロジェクトを更新できること" do
        project_params = FactoryBot.attributes_for(:project, name: "New Project Name")
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq "New Project Name"
      end
    end

    context "認可されていないユーザとして" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user, name: "Same Old Name")
      end

      it "プロジェクトを更新できないこと" do
        project_params = FactoryBot.attributes_for(:project, name: "New Name")
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq "Same Old Name"
      end

      it "ダッシュボードへリダイレクトすること" do
        project_params = FactoryBot.attributes_for(:project, name: "New Name")
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to root_path
      end
    end

    context "ゲストとして" do
      before do
        @project = FactoryBot.create(:project)
      end

      it "302レスポンスを返すこと" do
        project_params = FactoryBot.attributes_for(:project, name: "New Name")
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        project_params = FactoryBot.attributes_for(:project, name: "New Name")
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#destroy" do
    context "認可されたユーザとして" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "プロジェクトが削除できること" do
        sign_in @user
        expect {
          delete :destroy, params: { id: @project.id }
        }.to change(@user.projects, :count).by(-1)
      end
    end

    context "認可されていないユーザとして" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user, name: "Same Old Name")
      end

      it "プロジェクトを削除できないこと" do
        sign_in @user
        expect {
          delete :destroy, params: { id: @project.id }
        }.to_not change(Project, :count)
      end

      it "ダッシュボードへリダイレクトすること" do
        sign_in @user
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end

    context "ゲストとして" do
      before do
        @project = FactoryBot.create(:project)
      end

      it "302レスポンスを返すこと" do
        delete :destroy, params: { id: @project.id }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to "/users/sign_in"
      end

      it "プロジェクトを削除できないこと" do
        expect {
          delete :destroy, params: { id: @project.id }
        }.to_not change(Project, :count)
      end
    end
  end

  describe "#new" do
    context "認可されたユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "正常にレスポンスを返すこと" do
        sign_in @user
        get :new
        expect(response).to be_success
      end
    end

    context "ゲストとして" do
      it "302レスポンスを返すこと" do
        get :new
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        get :new
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#edit" do
    context "認可されたユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "正常にレスポンスを返すこと" do
        sign_in @user
        get :edit, params: { id: @project.id }
        expect(response).to be_success
      end
    end

    context "認可されていないユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it "ダッシュボードへリダイレクトすること" do
        sign_in @user
        get :edit, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end

    context "ゲストとして" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "302レスポンスを返すこと" do
        get :edit, params: { id: @project.id }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        get :edit, params: { id: @project.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

end
