require 'rails_helper'

RSpec.describe "TasksApi", type: :request do
  describe "GET /api/projects/:project_id/tasks" do
    context "自分のプロジェクトについて" do
      context "タスクがない場合" do 
        it "空のJSONを返すこと" do
          user = FactoryBot.create(:user)
          project = FactoryBot.create(:project, name: "Sample Project", owner: user)

          get api_project_tasks_path(project.id), params: {
            user_email: user.email,
            user_token: user.authentication_token
          }

          expect(response).to have_http_status(:success)
          json = JSON.parse(response.body)
          expect(json.length).to eq 0
        end
      end

      context "タスクがある場合" do
        it "読み出せること" do
          user = FactoryBot.create(:user)
          project = FactoryBot.create(:project, name: "Sample Project", owner: user)
          task1 = FactoryBot.create(:task, project: project, name: "タスク1")
          task2 = FactoryBot.create(:task, project: project, name: "タスク2")

          get api_project_tasks_path(project.id), params: {
            user_email: user.email,
            user_token: user.authentication_token
          }

          expect(response).to have_http_status(:success)
          json = JSON.parse(response.body)
          expect(json.length).to eq 2
          expect(json[0]["name"]).to eq "タスク1"
          expect(json[1]["name"]).to eq "タスク2"
        end
      end
    end

    context "自分以外のプロジェクトについて" do
      it "空のJSONを返すこと" do
        user = FactoryBot.create(:user)

        other_user = FactoryBot.create(:user)
        other_project = FactoryBot.create(:project, name: "Sample Project", owner: other_user)

        get api_project_tasks_path(other_project.id), params: {
          user_email: user.email,
          user_token: user.authentication_token
        }

        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json.length).to eq 0
      end
    end
  end

  describe "GET /api/projects/:project_id/tasks/:id" do
    context "自分のプロジェクトについて" do
      context "タスクがない場合" do 
        it "空のJSONを返すこと" do
          user = FactoryBot.create(:user)
          project = FactoryBot.create(:project, name: "Sample Project", owner: user)
          not_exists_task_id = 1

          get api_project_task_path(project.id,not_exists_task_id), params: {
            user_email: user.email,
            user_token: user.authentication_token
          }

          expect(response).to have_http_status(:success)
          json = JSON.parse(response.body)
          expect(json.length).to eq 0
        end
      end

      context "タスクがある場合" do
        it "読み出せること" do
          user = FactoryBot.create(:user)
          project = FactoryBot.create(:project, name: "Sample Project", owner: user)
          task1 = FactoryBot.create(:task, project: project, name: "タスク1")
          task2 = FactoryBot.create(:task, project: project, name: "タスク2")

          get api_project_task_path(project.id, task1.id), params: {
            user_email: user.email,
            user_token: user.authentication_token
          }
          expect(response).to have_http_status(:success)
          json = JSON.parse(response.body)
          expect(json["name"]).to eq "タスク1"

          get api_project_task_path(project.id, task2.id), params: {
            user_email: user.email,
            user_token: user.authentication_token
          }
          expect(response).to have_http_status(:success)
          json = JSON.parse(response.body)
          expect(json["name"]).to eq "タスク2"
        end
      end
    end

    context "自分以外のプロジェクトについて" do
      it "空のJSONを返すこと" do
        user = FactoryBot.create(:user)

        other_user = FactoryBot.create(:user)
        other_project = FactoryBot.create(:project, name: "Sample Project", owner: other_user)
        dummy_task_id = 1

        get api_project_task_path(other_project.id, dummy_task_id), params: {
          user_email: user.email,
          user_token: user.authentication_token
        }

        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json.length).to eq 0
      end
    end
  end
end
