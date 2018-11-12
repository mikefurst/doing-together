class ProfileController < ApplicationController
    before_action :authenticate_user!, only: [:update]
    before_action :check_authorization, only: [:update]
    skip_before_action :verify_authenticity_token

    def show
        @user = User.find(params[:id])
        
        @acts=Activity.select { |a| 
            if @user.groupid == nil
                a.userid == @user.id and ActivityType.find(a.actid).groupid == nil
            else
                User.find(a.userid).groupid == @user.groupid and a.groupid == @user.groupid and a.userid == @user.id
            end
        }.sort {|a,b| b.created_at <=> a.created_at}[0..3]
        
    end
    
    def edit
        @user = User.find(params[:id])
    end
    
    
    
    
    def update
        @user = User.find(params[:id])
        if @user.first_name != user_params[:first_name]
            @user.first_name = user_params[:first_name]
        end
        if @user.last_name != user_params[:last_name]
            @user.last_name = user_params[:last_name]
        end
        if @user.save
            render :status => "200", :text => "Success"
        else
            render :status => "200", :text => "Failure"
        end
    end
    
    private
    
    def check_authorization
        unless current_user.id == params[:id].to_i
            redirect_to root_url
        end
    end
    
    def user_params
        params.require(:user).permit(:first_name, :last_name)
    end
end
