#Controller for activity
class ActivityController < ApplicationController
    before_action :authenticate_user!
    def index
        if current_user.groupid==nil
            @group=nil
        else
            @group = Group.find(current_user.groupid)
        end
        
        @acts=Activity.select { |a| 
            if current_user.groupid == nil
                a.userid == current_user.id and ActivityType.find(a.actid).groupid == nil
            else
                User.find(a.userid).groupid == current_user.groupid and ActivityType.find(a.actid).groupid == current_user.groupid
            end
        }.sort {|a,b| b.created_at <=> a.created_at}

        session["last_load_timestamp"]=@acts[0].created_at.strftime("%s")
    end
    
    def new
        @act = Activity.new
        @act_types = ActivityType.select { |a| 
            if current_user.groupid == nil
                a.userid == current_user.id
            else
                a.groupid == current_user.groupid and a.verified
            end
        }.sort{ |a,b| a[:name]<=>b[:name] }
        if @act_types.blank?
            flash[:alert] = "There are no available activity types. Please create one first."
            redirect_to :action => 'index'
            return
        end
    end
    
    def show
        @act = Activity.find(params[:id])
        @actType = ActivityType.find(@act.actid)
        @updated = @act.created_at < @act.updated_at
        @user_name = User.find(@act.userid).first_name << ' ' << User.find(@act.userid).last_name
    end
    
    def act_params
        params.require(:activities).permit("actid","duration","userid")
    end
    def create
        @act = Activity.create(act_params)
        
        if @act.save
            redirect_to :action => 'index'
            return
        else
            redirect_to :action => 'new'
            return
        end
    end
    
    def edit
        @act = Activity.find(params[:id])
        @actType = ActivityType.find(@act.actid)
        @actTypes = ActivityType.all
        @user_id = @act.userid
    end
    def act_param
        params.require(:activity).permit("actid","duration","userid")
    end
    def update
        @act = Activity.find(params[:id])
        if @act.userid == current_user.id
            if @act.update_attributes(act_param)
                redirect_to :action => 'index'
                return
            else
                redirect_to :action => 'edit'
                return
            end
        end
    end
    
    def delete
        if current_user.id == Activity.find(params[:id]).userid
            Activity.find(params[:id]).destroy
        end
        redirect_to :action => 'index'
        return
    end
    
    def getNewActivities
        @acts = Activity.select {|a|
            if current_user.groupid==nil
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
    
end