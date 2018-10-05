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
        @group.adminid = current_user.id
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
        unless current_user.id == @group.adminid
            @admin = User.find(@group.adminid)
            flash[:alert] = "You do not have access to edit this group. Please contact your group administrator, " << @admin.full_name << "."
            redirect_to :action => 'index'
        end
        @users = User.all.select { |u|
            u.groupid == @group.id
        }
        @scores = {}
        @users.each { |u| 
            Activity.all.each { |act|
                if act.userid == u.id
                    if @scores[u.id]==nil
                        @scores[u.id] = act.duration * ActivityType.find(act.actid).score
                    else
                        @scores[u.id] += act.duration * ActivityType.find(act.actid).score
                    end
                end
            }
        }
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
            Activity.all.each { |act|
                if act.userid == u.id
                    if @scores[u.id]==nil
                        @scores[u.id] = act.duration * ActivityType.find(act.actid).score
                    else
                        @scores[u.id] += act.duration * ActivityType.find(act.actid).score
                    end
                end
            }
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
    end
    def delete
        @group = Group.find(params[:id])
        unless current_user.id == @group.adminid
            @admin = User.find(@group.adminid)
            flash[:alert] = "You do not have access to edit this group. Please contact your group administrator, " << @admin.first_name << " " << @admin.last_name << "."
            redirect_to :action => 'index'
        else
            User.all.each { |u|
                if u.groupid=@group.id
                    u.groupid=nil
                    u.save!
                end
            }
            @group.destroy
            redirect_to :action => 'index'
        end
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
