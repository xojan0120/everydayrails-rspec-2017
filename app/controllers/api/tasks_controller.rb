module Api
  class TasksController < ApplicationController
    before_action :set_tasks, only: [:index, :show]

    prepend_before_action :authenticate_user_from_token!

    def index
      render json: @tasks
    end

    def show
      if !@tasks.empty? && task = @tasks.find_by(id: params[:id])
        render json: task
      else
        render json: []
      end
    end

    private

      def set_tasks
        if project = current_user.projects.find_by(id: params[:project_id])
          @tasks = project.tasks
        else
          @tasks = []
        end
      end

  end
end
