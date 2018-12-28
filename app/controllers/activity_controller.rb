#Controller for activity
class ActivityController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token
    
    def index
        if current_user.groupid == nil
            @a2u = ActivityToUser.select { |a|
                a.userid == current_user.id
            }
            @acts = Array.new
            @a2u.each {|a|
                act = a.getActivity()
                if act.groupid == nil
                    @acts.push(act)
                end
            }
            @acts.sort {|a,b| b.created_at <=> a.created_at}
            if not @acts.blank?
                session["last_load_timestamp"]=@acts[0].created_at.strftime("%s")
            end
            @at2u = ActivityTypeToUser.select {|a|
                a.userid == current_user.id
            }
            @act_types = Array.new
            @at2u.each {|a|
                act = a.getActivityType()
                if act.groupid == nil
                    @act_types.push(act)
                end
            } 
            @act_types.sort{ |a,b| a[:name]<=>b[:name] }
        else
            @group = current_user.group
            @a2g = ActivityToGroup.select {|a|
                a.groupid == @group.id
            }
            @acts = Array.new
            @a2g.each { |a|
                act = a.getActivity()
                @acts.push(act)
            }
            @acts.sort {|a,b| b.created_at <=> a.created_at}
            if not @acts.blank?
                session["last_load_timestamp"]=@acts[0].created_at.strftime("%s")
            end
            @at2g = ActivityTypeToGroup.select {|a|
                a.groupid == @group.id
            }
            @act_types = Array.new
            @at2g.each {|a|
                act = a.getActivityType()
                @act_types.push(act)
            } 
            @act_types.sort{ |a,b| a[:name]<=>b[:name] }
        end
        
    end
    
    def new
        redirect_to :action => 'index'
        flash[:alert]="This page is depracated. Please use the popup form."
        return
    end
    
    def show
        @act = Activity.find(params[:id])
        @actType = ActivityType.find(@act.actid)
        @user_name = User.find(@act.userid).first_name << ' ' << User.find(@act.userid).last_name
    end
    
    def act_params
        params.require(:activities).permit("actid","duration","userid")
    end
    def create
        if act_params[:duration].to_f <= 0
            return false
        elsif act_params[:userid].to_i != current_user.id
            return false
        elsif ActivityType.find(act_params[:actid].to_i).groupid != current_user.groupid
            return false
        end
        @act = Activity.create(act_params)
        @act.save!
    end
    
    def edit
        @act = Activity.find(params[:id])
        @actType = ActivityType.find(@act.actid)
        @actTypes = ActivityType.all
        @user_id = @act.userid
    end
    def act_param
        params.require(:activity).permit("actid","duration","aid")
    end
    def update
        @act = Activity.find(act_param[:aid])
        unless @act == nil
            if @act.userid == current_user.id
                if @act.update_attributes(
                    :actid => act_param[:actid], 
                    :duration => act_param[:duration]
                )
                    render :status => "200", :text => "Success"
                else
                    render :status => "200", :text => "Failure"
                end
            end
        end
    end
    
    def delete
        if current_user.id == Activity.find(params[:id]).userid
            if Activity.find(params[:id]).destroy
                render :status => "200", :text => "Success"
            else
                render :status => "200", :text => "Failure"
            end
        end
    end
    
    def getNewActivities
        @acts = Activity.select {|a|
            if session["last_load_timestamp"]==nil
                if current_user.groupid==nil
                    a.user_id==current_user.id and a.groupid==nil
                else
                    a.groupid==current_user.groupid
                end
            elsif current_user.groupid==nil
                a.created_at.strftime("%s") > session["last_load_timestamp"] and a.user_id==current_user.id and a.groupid==nil
            else
                a.created_at.strftime("%s") > session["last_load_timestamp"] and a.groupid==current_user.groupid
            end
        }.sort {|a,b| a.created_at <=> b.created_at}
        if @acts.blank?
            render :status => "200", :text => "Nothing New"
        else
            render :status => "200", :json => @acts.last.getNewActivityJSON(current_user.id)
            session["last_load_timestamp"] = @acts.last.created_at.strftime("%s")
        end
    end
    
    def getActivity
        if params[:actid]==nil or Activity.find(params[:actid])==nil
            render :status => "200", :text => "Does Not Exist"
        else
            render :status => "200", :json => Activity.find(params[:actid]).getActivityJSON(current_user.id)
        end
    end
end