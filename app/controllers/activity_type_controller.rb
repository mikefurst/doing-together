class ActivityTypeController < ApplicationController
    def index
        if current_user.groupid == nil
            @groupAdminID=nil
        else
            @groupAdminID = Group.find(current_user.groupid).adminid
        end
        @actTypes = ActivityType.select { |act|
                if current_user.groupid==nil
                    act.userid==current_user.id
                else
                    if current_user.id == @groupAdminID
                        act.groupid==current_user.groupid
                    else
                        act.groupid==current_user.groupid and act.verified
                    end
                end
            }.sort{ |a,b| a[:name]<=>b[:name] }
    end
    
    def new
        @actType = ActivityType.new
        @actTypes = ActivityType.select { |act|
                if current_user.groupid==nil
                    act.userid==current_user.id
                else
                    act.groupid==current_user.groupid and act.verified
                end
            }.sort{ |a,b| a[:name]<=>b[:name] }
        if current_user.groupid == nil
            @groupAdminID=nil
        else
            @groupAdminID = Group.find(current_user.groupid).adminid
        end
    end
    
    def acttype_params
        params.require(:activitytypes).permit("name","score")
    end
    def create
        @actType = ActivityType.create(acttype_params)
        
        if current_user.groupid==nil
            @actType.userid=current_user.id
        else
            @actType.groupid=current_user.groupid
            if Group.find(current_user.groupid).adminid==current_user.id
                @actType.verified=true
            else
                @actType.verified=false
            end
        end
        
        if @actType.save
            if @actType.verified==nil
                flash[:alert] = "Activity type has been registered and is now available to only you."
            elsif @actType.verified
                flash[:alert] = "Activity type has been registered and is now available to everyone in your group."
            else
                flash[:alert] = "Activity type has been registered successfully and will be available once your group's administrator has approved it."
            end
            redirect_to :action => 'index'
            return
        else
            flash[:alert] = "Failed to create the activity type. Please verify what you have entered is valid."
            redirect_to :action => 'new'
            return
        end
    end
    
    def edit
        if current_user.groupid == nil
            @actType = ActivityType.find(params[:id])
            unless @actType.groupid == nil and @actType.userid == current_user.userid
                flash[:alert] = "You do not have access to this activity type."
                redirect_to :action => 'index'
                return
            end
            
        else
            unless Group.find(current_user.groupid).adminid==current_user.id
                flash[:alert] = "You must be the group's administrator to edit activity types."
                redirect_to :action => 'index'
                return
            else
                @actType = ActivityType.find(params[:id])
                unless @actType.groupid == current_user.groupid
                    flash[:alert] = "You do not have access to this activity type."
                    redirect_to :action => 'index'
                    return
                end
            end
        end
    end
    
    def acttype_param
        params.require(:activity_type).permit('name','score')
    end
    def update
        @actType = ActivityType.find(params[:id])
        if not @actType.userid==nil
            unless @actType.userid == current_user.id
                flash[:alert] = "You do not have access to this activity type."
                redirect_to :action => 'index'
                return
            end
            if @actType.update_attributes(acttype_param)
                flash[:alert] = "Activity type was successfully updated."
                redirect_to :action => 'index'
                return
            else
                flash[:alert] = "There was an error editing the entry. Please try again."
                redirect_to :action => 'edit'
                return
            end
        elsif not @actType.groupid == nil
            unless Group.find(current_user.groupid).adminid==current_user.id
                flash[:alert] = "You must be the group's administrator to edit activity types."
                redirect_to :action => 'index'
                return
            end
            if @actType.update_attributes(acttype_param)
                @actType.verified = true
                @actType.save
                flash[:alert] = "Activity type was successfully updated."
                redirect_to :action => 'index'
                return
            else
                flash[:alert] = "There was an error editing the entry. Please try again."
                redirect_to :action => 'edit'
                return
            end
        else
            flash[:alert] = "Activity type encountered an unknown error when updating."
            redirect_to :action => 'index'
            return
        end
    end
end
