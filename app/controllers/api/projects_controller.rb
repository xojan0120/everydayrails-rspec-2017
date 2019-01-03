module Api
  class ProjectsController < ApplicationController
    before_action :set_projects, only: [:index, :show]

    prepend_before_action :authenticate_user_from_token!

    def index
      render json: @projects
    end

    def show
      if project = @projects.find_by(id: params[:id])
        render json: project
      else
        render json: []
      end
    end

    def create
      @project = current_user.projects.new(project_params)

      if @project.save
        render json: { status: :created }
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    private

      def set_projects
        @projects = current_user.projects
      end

      def project_params
        params.require(:project).permit(:name, :description, :due_on)
      end
  end
end
