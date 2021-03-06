class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :complete, :incomplete]
  before_action :project_owner?, except: [:index, :all, :new, :create]

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects.where(completed: false)
    @all_flag = false
  end

  def all
    @projects = current_user.projects
    @all_flag = true
    render :index
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.projects.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def complete
    if @project.complete
      redirect_to @project, notice: "Congratulations, this project is complete!"
    else
      redirect_to @project, alert: "Unable to complete project."
    end
  end

  def incomplete
    if @project.incomplete
      redirect_to @project, notice: "Congratulations, this project is incomplete!"
    else
      redirect_to @project, alert: "Unable to incomplete project."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      #@project = Project.find(params[:id])
      if Project.exists?(params[:id])
        @project = Project.find(params[:id])
      else
        redirect_to root_path, alert: "プロジェクトが存在しない"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :description, :due_on)
    end
end
