class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  protected

    def set_project
      @project = Project.find(params[:project_id])
    end

    def project_owner?
      unless @project.owner == current_user
        redirect_to root_path, alert: "You don't have access to that project."
      end
    end

  private

    def authenticate_user_from_token!
      user_email = params[:user_email].presence
      user = user_email && User.find_by(email: user_email)
      if user && Devise.secure_compare(user.authentication_token, params[:user_token])
        sign_in user, store: true
      else
        render json: { status: "auth failed" }
        false
      end
    end
end
