class GroupController < ApplicationController
    before_action :authenticate_user!
    
    def index
        @groups = Group.all
    end
    def new
    end
    def group_params
        params.require(:group).permit("name","description","password")
    end
    def create
        @group = Group.create()
        @group.name=group_params[:name]
        @group.description=group_params[:description]
        @group.password=group_params[:password]
        if @group.save!
            flash[:alert] = "You have created and been added to group " << group_params[:name]
            current_user.groupid = @group.id
            current_user.save!
            redirect_to :action => 'index'
        else
            redirect_to :action => 'new'
        end
    end
    def edit
        @group = Group.find(params[:id])
        unless current_user.groupid == @group.id
            flash[:alert] = "You do not have access to this group. Please join it first."
            redirect_to :action => 'index'
        end
    end
    def group_param
        params.require(:group).permit("name","description","password")
    end
    def update
        @group = Group.find(params[:id])
        unless current_user.groupid == @group.id
            flash[:alert] = "You do not have access to this group. Please join it first."
            redirect_to :action => 'index'
        end
        @group.name=group_param[:name]
        @group.description=group_param[:description]
        unless group_param[:password]==nil or group_param[:password]==''
            @group.password=group_param[:password]
        end
        @group.save!
        redirect_to :action => 'index'
    end
    def delete
        @group = Group.find(params[:id])
        unless current_user.groupid == @group.id
            flash[:alert] = "You do not have access to this group. Please join it first."
            redirect_to :action => 'index'
        end
        @group.destroy
        User.all.each { |u|
            if u.groupid=params[:id]
                u.groupid=nil
            end
        }
        redirect_to :action => 'index'
    end
    def show
        @group = Group.find(params[:id])
    end
    def join_params
        params.require(:group).permit("password")
    end
    def join
        @group = Group.find(params[:id])
        if @group.password == join_params[:password]
            current_user.groupid = @group.id
            if current_user.save!
                flash[:alert]="You have now joined the group: " << @group.name << "."
            else
                flash[:alert]="Unexpected error when joining the group: " << @group.name << ". Please try again."
            end
            redirect_to :action => 'index'
        else
            flash[:alert]="You entered an incorrect password for the group."
            redirect_to :action => 'show', :id => params[:id]
        end
    end
end
