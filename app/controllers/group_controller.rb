class GroupController < ApplicationController
    before_action :authenticate_user!
    
    def index
        @groups = Group.all
    end
    def new
        @maximumNameLength = 50
        @minimumNameLength = 10
        @maximumDescriptionLength = 150
        @minimumDescriptionLength = 15
    end
    def group_params
        params.require(:group).permit("name","description","password","password_confirmation")
    end
    def create
        @group = Group.create()
        @group.name=group_params[:name]
        @group.description=group_params[:description]
        if @group.name.length > 50
            flash[:alert] = "Groups have a maximum name length of 50 characters."
            redirect_to :action => 'new'
            return
        elsif @group.name.length < 10
            flash[:alert] = "Groups have a minimum name length of 10 characters."
            redirect_to :action => 'new'
            return
        elsif @group.description.length > 150
            flash[:alert] = "Groups have a maximum description length of 150 characters."
            redirect_to :action => 'new'
            return
        elsif @group.description.length < 15
            flash[:alert] = "Groups have a minimum description length of 15 characters."
            redirect_to :action => 'new'
            return
        elsif group_params[:password] != group_params[:password_confirmation]
            flash[:alert] = "Passwords do not match."
            redirect_to :action => 'new'
            return
        end
        @group.password=group_params[:password]
        @group.adminid = current_user.id
        if @group.save!
            flash[:alert] = "You have created and been added to group " << group_params[:name]
            current_user.groupid = @group.id
            current_user.save!
            redirect_to :action => 'index'
            return
        else
            redirect_to :action => 'new'
            return
        end
    end
    def edit
        @group = Group.find(params[:id])
        unless current_user.id == @group.adminid
            @admin = User.find(@group.adminid)
            flash[:alert] = "You do not have access to edit this group. Please contact your group administrator, " << @admin.full_name << "."
            redirect_to :action => 'index'
            return
        end
        @users = User.all.select { |u|
            u.groupid == @group.id
        }
        @scores = {}
        @users.each { |u| 
            @scores[u.id] = u.score
        }
        @maximumNameLength = 50
        @minimumNameLength = 10
        @maximumDescriptionLength = 150
        @minimumDescriptionLength = 15
    end
    def view
        @group = Group.find(params[:id])
        unless current_user.groupid == @group.id
            flash[:alert] = "You do not have access to this group. Please join it first."
            redirect_to :action => 'index'
        end
        @users = User.all.select { |u|
            u.groupid == @group.id
        }
        @scores = {}
        @users.each { |u| 
            @scores[u.id] = u.score
        }
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
        return
    end
    def delete
        @group = Group.find(params[:id])
        unless current_user.id == @group.adminid
            @admin = User.find(@group.adminid)
            flash[:alert] = "You do not have access to edit this group. Please contact your group administrator, " << @admin.first_name << " " << @admin.last_name << "."
            redirect_to :action => 'index'
            return
        else
            User.all.each { |u|
                if u.groupid=@group.id
                    u.groupid=nil
                    u.save!
                end
            }
            ActivityType.all.each {|act|
                if act.groupid==@group.id
                    act.destroy
                end
            }
            @group.destroy
            redirect_to :action => 'index'
            return
        end
    end
    def show
        @group = Group.find(params[:id])
        if @group.password == nil 
            redirect_to :access => 'join', :id => params[:id], :password => nil
            return
        elsif @group.password==''
            redirect_to :action => 'join', :id => params[:id], :password => ''
            return
        end
    end
    def join_params
        params.require(:group).permit("password")
    end
    def join
        @group = Group.find(params[:id])
        unless current_user.groupid==nil
            @curGroup = Group.find(current_user.groupid)
            if @curGroup.adminid==current_user.id
                flash[:alert]="You cannot join another group while you are still the admin of " << @curGroup.name << "."
                redirect_to :action => 'index'
                return
            end
        end
        if @group.password == join_params[:password]
            current_user.groupid = @group.id
            if current_user.save!
                flash[:alert]="You have now joined the group: " << @group.name << "."
            else
                flash[:alert]="Unexpected error when joining the group: " << @group.name << ". Please try again."
            end
            redirect_to :action => 'index'
            return
        else
            flash[:alert]="You entered an incorrect password for the group."
            redirect_to :action => 'show', :id => params[:id]
            return
        end
    end
    def leave
        current_user.groupid=nil
        current_user.save!
        flash[:alert]="You have left the group."
        redirect_to :action => 'index'
    end
    def kick
        @group = Group.find(params[:id])
        unless current_user.id == @group.adminid
            flash[:alert] = "You do not have access to edit this group. Please contact your group administrator, " << @admin.first_name << " " << @admin.last_name << "."
            redirect_to :action => 'index'
        end
        @user = User.find(params[:uid])
        @user.groupid = nil
        @user.save!
        redirect_to :action => 'edit', :id => params[:id]
    end
    def makeadmin
        @group = Group.find(params[:id])
        unless current_user.id == @group.adminid
            flash[:alert] = "You do not have access to edit this group. Please contact your group administrator, " << @admin.first_name << " " << @admin.last_name << "."
            redirect_to :action => 'index'
            return
        end
        @user = User.find(params[:uid])
        unless @user==nil
            @group.adminid = @user.id
            @group.save!
        else
            flash[:alert] = "Invalid User!"
            redirect_to :action => 'edit', :id => params[:id]
        end
        redirect_to :action => 'index'
    end
end
