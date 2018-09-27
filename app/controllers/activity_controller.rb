#Controller for activity
class ActivityController < ApplicationController
    def index
        @acts=Activity.all
        @actTypes = ActivityType.all
    end
    
    def new
        @act = Activity.new
        @act_types = ActivityType.all.sort{ |a,b| a[:name]<=>b[:name] }
    end
    
    def show
        @act = Activity.find(params[:id])
        @actType = ActivityType.find(@act.actid)
        @updated = @act.created_at < @act.updated_at
    end
    
    def act_params
        params.require(:activities).permit("actid","duration","user")
    end
    def create
        @act = Activity.create(act_params)
        
        if @act.save
            redirect_to :action => 'index'
        else
            redirect_to :action => 'new'
        end
    end
    
    def edit
        @act = Activity.find(params[:id])
        @actType = ActivityType.find(@act.actid)
        @actTypes = ActivityType.all
    end
    def act_param
        params.require(:activity).permit("actid","duration","user")
    end
    def update
        @act = Activity.find(params[:id])
        
        if @act.update_attributes(act_param)
            redirect_to :action => 'index'
        else
            redirect_to :action => 'edit'
        end
    end
    
    def delete
        Activity.find(params[:id]).destroy
        redirect_to :action => 'index'
    end
    
    
end