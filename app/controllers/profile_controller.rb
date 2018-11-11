class ProfileController < ApplicationController
    before_action :authenticate_user!, only: [:update]
    before_action :check_authorization, only: [:update]
    before_action :set_user
  

    def show
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
