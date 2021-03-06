class GroupController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token
    
    def index
        @groups = Group.all
        @maximumNameLength = 50
        @minimumNameLength = 10
        @maximumDescriptionLength = 150
        @minimumDescriptionLength = 15
        @templates = {
            :None => "Use no template. This is for groups who want to make all of their own activites.",
            :General_Fitness => "A template for groups who are trying to get fit and healthy. Contains some basic activities for getting healthy.",
            :Reading => "A template for groups who are trying to read more. This includes some activities that are scored based on how long one reads, to be more reader friendly. ",
            :Housework_and_Cleaning => "A template for groups who focused on doing more around the house. Contains basic chores and things you can do around the house. ",
            :Trying_New_Things => "A template for groups who value trying new things. This includes some activities that are focused around trying new things like learning a language or a new instrument.",
            :Aerobic_Fitness => "A template for groups who want to be healthy and undergo some intense workouts. Contains some basic activities for basic aerobic activies."
        }
    end
    def new
        flash[:alert]="This method is deprecated."
        redirect_to :action => index
    end
    def group_params
        params.require(:group).permit("name","description","password","password_confirmation","template")
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
            
            if group_params[:template] == "General_Fitness"
                activitytypelist = [
                    {
                        :name => "Walking",
                        :score => 1
                    },
                    {
                        :name => "Jogging",
                        :score => 1.25
                    },
                    {
                        :name => "Running",
                        :score => 1.50
                    },
                    {
                        :name => "Swimming",
                        :score => 1.75
                    },
                    {
                        :name => "Martial Arts",
                        :score => 2.00
                    }
                ]
            elsif group_params[:template] == "Reading"
                activitytypelist = [
                    {
                        :name => "Reading Academic Articles",
                        :score => 3
                    },
                    {
                        :name => "Reading Poetry",
                        :score => 2.85
                    },
                    {
                        :name => "Reading Novels",
                        :score => 2.5
                    },
                    {
                        :name => "Reading Books",
                        :score => 2.15
                    },
                    {
                        :name => "Reading Anthologies",
                        :score => 2
                    },
                    {
                        :name => "Reading Ethnographies",
                        :score => 1.85
                    },
                    {
                        :name => "Reading short stories",
                        :score => 1.5
                    },
                    {
                        :name => "Reading News Articles",
                        :score => 1.15
                    },
                    {
                        :name => "Reading Magazine Articles",
                        :score => 1
                    }
                ]
            elsif group_params[:template] == "Housework_and_Cleaning"
                activitytypelist = [
                    {
                        :name => "Wash Dishes",
                        :score => 1.4
                    },
                    {
                        :name => "Do the Laundry",
                        :score => 2.25
                    },
                    {
                        :name => "Mow the Lawn",
                        :score => 3.6
                    },
                    {
                        :name => "Dust a Room",
                        :score => 1
                    },
                    {
                        :name => "Vacuum a Room",
                        :score => 1.05
                    },
                    {
                        :name => "Clean Bathroom",
                        :score => 2.4
                    },
                    {
                        :name => "Mop a Room",
                        :score => 1.1
                    },
                    {
                        :name => "Clean Fans",
                        :score => 1.15
                    },
                    {
                        :name => "Take Out Trash",
                        :score => 1
                    }
                ]
            elsif group_params[:template] == "Trying_New_Things"
                activitytypelist = [
                    {
                        :name => "Practice Foreign Language",
                        :score => 2
                    },
                    {
                        :name => "Begin Learning New Foreign Language",
                        :score => 4
                    },
                    {
                        :name => "Practice Instrument",
                        :score => 2
                    },
                    {
                        :name => "Begin Learning New Instrument",
                        :score => 4
                    },
                    {
                        :name => "Write Short Story",
                        :score => 2
                    },
                    {
                        :name => "Write Poetry",
                        :score => 1
                    },
                    {
                        :name => "Paint a Picture",
                        :score => 2
                    },
                    {
                        :name => "Sew",
                        :score => 1.5
                    },
                    {
                        :name => "Practice Singing",
                        :score => 3
                    },
                    {
                        :name => "Practice Juggling",
                        :score => 1
                    }
                ]
            elsif group_params[:template] == "Aerobic_Fitness"
                activitytypelist = [
                    {
                        :name => "Walking",
                        :score => 1
                    },
                    {
                        :name => "Slide Aerobics",
                        :score => 2
                    },
                    {
                        :name => "Step Aerobics",
                        :score => 3
                    },
                    {
                        :name => "Water Aerobics",
                        :score => 2.5
                    },
                    {
                        :name => "Jogging",
                        :score => 1.75
                    },
                    {
                        :name => "Bicycling",
                        :score => 2.15
                    },
                    {
                        :name => "Swimming",
                        :score => 2
                    }
                ]
            end
            unless activitytypelist == nil
                activitytypelist.each { |atype|
                        @act = ActivityType.create(atype)
                        @act.groupid = @group.id
                        @act.verified = true
                        @act.save!
                    }
            end
            
            render :status => "200", :text => @group.id.to_s
        else
            render :status => "200", :text => "ERROR"
        end
    end
    def edit
        @group = Group.find(params[:id])
        unless current_user.id == @group.adminid
            @admin = User.find(@group.adminid)
            flash[:alert] = "You do not have access to edit this group. Please contact your group administrator, " << @admin.full_name << "."
            redirect_to :action => 'view', :id => params[:id]
            return
        end
        @users = User.all.select { |u|
            u.groupid == @group.id
        }
        @scores = {}
        @users.each { |u| 
            @scores[u.id] = u.score
        }
        @messages = GroupMessage.select { |g|
            g.groupid == current_user.groupid
        }.sort {|a,b| a.timeAsInt <=> b.timeAsInt}
        unless @messages.blank?
            session["last-message"] = @messages.last.timeAsInt
        end
        @maximumNameLength = 50
        @minimumNameLength = 10
        @maximumDescriptionLength = 150
        @minimumDescriptionLength = 15
    end
    def view
        @group = Group.find(params[:id])
        if current_user.id == @group.adminid
            redirect_to :action => 'edit', :id => params[:id]
            return
        end
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
        @messages = GroupMessage.select { |g|
            g.groupid == current_user.groupid
        }.sort {|a,b| a.timeAsInt <=> b.timeAsInt}
        unless @messages.blank?
            session["last-message"] = @messages.last.timeAsInt
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
                if u.groupid==@group.id
                    u.groupid=nil
                    u.save!
                end
            }
            ActivityType.all.each {|act|
                if act.groupid==@group.id
                    Activity.all.each {|a|
                        if a.actid == act.id
                            a.destroy
                        end
                    }
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
                if @group.adminid == nil
                    @group.adminid = current_user.id
                    @group.save!
                end
                flash[:alert]="You have now joined the group: " << @group.name << "."
            else
                flash[:alert]="Unexpected error when joining the group: " << @group.name << ". Please try again."
            end
            redirect_to :action => 'view', :id => @group.id
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
        redirect_to :action => 'view', :id => params[:id]
    end
    def submitmessage
        @messageText = params[:message]
        @message = GroupMessage.create(:userid => current_user.id, :groupid => current_user.groupid, :message => @messageText)
        @message.message = @messageText
        unless @messageText==nil or @messageText=="" or @messageText.length > 140 or @messageText.length <= 0
            @message.save!
        end
    end
    def getNewMessage
        @messages = GroupMessage.select {|msg|
            if session["last-message"]==nil
                msg.groupid == current_user.groupid
            else
                msg.groupid == current_user.groupid and session["last-message"] < msg.timeAsInt
            end
        }.sort {|a,b| a.timeAsInt <=> b.timeAsInt }
        if @messages.blank?
            render :status => "200", :text => "Nothing New"
        else
            render :status => "200", :json => @messages[0].getNewMessageJSON(current_user.id)
            session["last-message"] = @messages[0].timeAsInt
        end
    end
    
    def verifyUser(email)
        if email==nil
            return "Invalid Email Entry"
        else
            @user = User.find_for_authentication(:email => email)
            if @user == nil
                return "User does not exist"
            end
            unless @user.groupid == nil
                if @user.groupid == current_user.groupid
                    return "User is already a member of the group"
                else
                    return "User is already a member of a group"
                end
            end
        end
        @invites = GroupInvite.select {|gInv|
            gInv.groupID == current_user.groupid and gInv.targetID==@user.id
        }
        unless @invites.blank?
            return "User has already been invited"
        end
        return "User can be invited"
    end
    
    def verifyUserCanBeAddedToGroup
        @check = verifyUser(params[:userEmail])
        render :status => "200", :text => @check
    end
    
    def requestNewInvite
        unless params[:groupID] == nil or params[:message] == nil or params[:message].length < 1
            @group = Group.find(params[:groupID])
            @message = GroupInvite.create(:groupID => params[:groupID], :targetID => @group.adminid, :message => params[:message], :toJoin => false, :creatorID => current_user.id)
            if @message.save
                render :status => "200", :text => "Success"
            else
                render :status => "200", :text => "Failure"
            end
        else
            render :status => "200", :text => "Failure"
            return
        end
    end
    
    def createNewInvite
        unless current_user.isAdmin or params[:email]==nil or params[:message] == nil or params[:message].length < 1
            render :status => "200", :text => "Failure"
            return
        end
        @check = verifyUser(params[:email])
        if @check == "User can be invited"
            @user = User.find_for_authentication(:email => params[:email])
            @message = GroupInvite.create(:groupID => current_user.groupid, :targetID => @user.id, :message => params[:message], :toJoin => true, :creatorID => current_user.id)
            if @message.save
                render :status => "200", :text => "Success"
            else
                render :status => "200", :text => "Failure"
            end
        else
            render :status => "200", :text => @check
            return
        end
    end
    def getInviteMessage
        unless user_signed_in?
            render :status => '200', :text => 'BAD'
            return
        else
            @invites = GroupInvite.select{ |grpInv|
                grpInv.targetID == current_user.id
            }
            if @invites.blank?
                render :status => '200', :text => 'BAD'
                return
            end
            unless current_user.groupid == nil or current_user.isAdmin
                @invites.each {|inv|
                    inv.delete
                }
                render :status => '200', :text => 'BAD'
                return
            end
            if current_user.isAdmin
                @invites.each {|inv|
                    if inv.toJoin 
                        inv.delete
                    end
                }
            end
            @invites.sort {|a,b| 
                a.created_at <=> b.created_at
            }
            render :status => '200', :json => @invites[0].makeJSON;
        end
    end
    def rejectInvite
        if params[:inviteID] == nil
            render :status => '200', :text => 'FAILURE_R'
            return
        end
        @invite = GroupInvite.find(params[:inviteID])
        if @invite == nil
            render :status => '200', :text => 'FAILURE_R'
            return
        end
        if @invite.delete
            render :status => '200', :text => 'SUCCESS_R'
        else
            render :status => '200', :text => 'FAILURE_R'
        end
    end
    def acceptInvite
        if params[:inviteID] == nil
            render :status => '200', :text => 'FAILURE_R'
            return
        end
        @invite = GroupInvite.find(params[:inviteID])
        if @invite == nil
            render :status => '200', :text => 'FAILURE_R'
            return
        end
        @group = Group.find(@invite.groupID)
        if @group == nil
            render :status => '200', :text => 'FAILURE_R'
        end
        current_user.groupid = @group.id
        if current_user.save
            @invites = GroupInvite.select{ |grpInv|
                grpInv.targetID == current_user.id
            }
            @invites.each {|inv|
                inv.delete
            }
            render :status => '200', :text => 'SUCCESS_A'
        else
            render :status => '200', :text => 'FAILURE_R'
        end
    end
    def acceptRequest
         if params[:inviteID] == nil
            render :status => '200', :text => 'FAILURE_0'
            return
        end
        @invite = GroupInvite.find(params[:inviteID])
        if @invite == nil
            render :status => '200', :text => 'FAILURE_0'
            return
        end
        @group = Group.find(@invite.groupID)
        if @group == nil
            render :status => '200', :text => 'FAILURE_0'
        end
        @user = User.find(@invite.creatorID)
        @user.groupid = @group.id
        if @user.save
            @invites = GroupInvite.select{ |grpInv|
                grpInv.creatorID == @user.id or grpInv.targetID == @user.id
            }
            @invites.each {|inv|
                inv.delete
            }
            render :status => '200', :text => 'SUCCESS_0'
        else
            render :status => '200', :text => 'FAILURE_0'
        end
    end
    def rejectRequest
        if params[:inviteID] == nil
            render :status => '200', :text => 'FAILURE_1'
            return
        end
        @invite = GroupInvite.find(params[:inviteID])
        if @invite == nil
            render :status => '200', :text => 'FAILURE_1'
            return
        end
        if @invite.delete
            render :status => '200', :text => 'SUCCESS_1'
        else
            render :status => '200', :text => 'FAILURE_1'
        end
    end
end
