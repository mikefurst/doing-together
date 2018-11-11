class ProfileController < ApplicationController
    before_action :authenticate_user!, only: [:update]
    before_action :check_authorization, only: [:update]
    skip_before_action :verify_authenticity_token

    def show
        @user = User.find(params[:id])
        @acts=Activity.select { |a| 
            if current_user.groupid == nil
                a.userid == current_user.id and ActivityType.find(a.actid).groupid == nil
            else
                User.find(a.userid).groupid == current_user.groupid and ActivityType.find(a.actid).groupid == current_user.groupid
            end
        }.sort {|a,b| b.created_at <=> a.created_at}
        if not @acts.blank?
            session["last_load_timestamp"]=@acts[0].created_at.strftime("%s")
        end
        @act = Activity.new
        @act_types = ActivityType.select { |a| 
            if current_user.groupid == nil
                a.userid == current_user.id
            else
                a.groupid == current_user.groupid and a.verified
            end
        }.sort{ |a,b| a[:name]<=>b[:name] }
        
        
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
