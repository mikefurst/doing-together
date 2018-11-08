class ActivityTypeController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token
    
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
        if acttype_params[:name]==nil or acttype_params[:name]==""
            flash[:alert]="Activity Type needs a name."
            redirect_to :action => 'new'
            return
        elsif acttype_params[:score]==nil
            flash[:alert]="Activity Type must have a score".
            redirect_to :action => 'new'
            return
        elsif acttype_params[:name].length<5
            flash[:alert]="Activity Type name is too short."
            redirect_to :action => 'new'
            return
        elsif acttype_params[:name].length>50
            flash[:alert]="Activity Type name is too long."
            redirect_to :action => 'new'
            return
        end
        ActivityType.all.each { |act|
            if current_user.groupid == nil
                if act.userid == current_user.id
                    if act.name == acttype_params[:name]
                        render :status => "200", :text => "Failure_E"
                        return
                    end
                end
            else
                if act.groupid == current_user.groupid
                    if act.name == acttype_params[:name]
                        render :status => "200", :text => "Failure_E"
                        return
                    end
                end
            end
        }
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
            if @actType.verified
                render :status => "200", :text => "Success_V"
            else
                render :status => "200", :text => "Success"
            end
            return
        else
            render :status => "200", :text => "Failure"
            return
        end
    end
    
    def edit
        if current_user.groupid == nil
            @actType = ActivityType.find(params[:id])
            unless @actType.groupid == nil and @actType.userid == current_user.id
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
                render :status => "200", :text => "Failure"
                return
            end
            if @actType.update_attributes(acttype_param)
                render :status => "200", :text => "Success"
                return
            else
                render :status => "200", :text => "Failure"
                return
            end
        elsif not @actType.groupid == nil
            unless current_user.isAdmin and @actType.groupid == current_user.groupid
                render :status => "200", :text => "Failure"
                return
            end
            if @actType.update_attributes(acttype_param)
                @actType.verified = true
                @actType.save
                render :status => "200", :text => "Success"
                return
            else
                render :status => "200", :text => "Failure"
                return
            end
        else
            render :status => "200", :text => "Failure"
            return
        end
    end
    
    def delete
        @acttype = ActivityType.find(params[:id])
        if current_user.groupid == @acttype.group and current_user.isAdmin
            if @acttype.destroy
                render :status => "200", :text => "Success"
            else
                render :status => "200", :text => "Failure"
            end
        end
    end
    
    def verify
        @actType = ActivityType.find(params[:id])
        if current_user.groupid == @actType.groupid and current_user.isAdmin
            @actType.verified = true
            @actType.save
            render :status => "200", :text => "Success"
            return
        end
        render :status => "200", :text => "Failure"
    end
    
    def getActivityType
        if params[:actid]==nil or ActivityType.find(params[:actid])==nil
            render :status => "200", :text => "Does Not Exist"
        elsif ActivityType.find(params[:actid]).groupid == nil
            if ActivityType.find(params[:actid]).userid == current_user.id
                render :status => "200", :json => ActivityType.find(params[:actid]).getActivityTypeJSON(current_user)
            else
                render :status => "200", :text => "Cannot Access"
            end
        elsif ActivityType.find(params[:actid]).groupid != current_user.groupid
            render :status => "200", :text => "Cannot Access"
        else
            render :status => "200", :json => ActivityType.find(params[:actid]).getActivityTypeJSON(current_user)
        end
    end
    
end
