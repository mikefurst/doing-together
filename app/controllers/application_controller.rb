class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end
  
  def index
  end
  

end

class UsersController < ApplicationController
  
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :check_authorization, only: [:edit, :update]
  before_action :set_user
  

  def show
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to @user
    else
      flash.now[:alert] = "Something Went Wrong. Please try again"
      render :edit
    end
  end
  
  private
  
    def check_authorization
      unless current_user.id == params[:id].to_i
        redirect_to root_url
      end
    end
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:first_name, :last_name, :avatar, :remove_avatar)
    end
end

