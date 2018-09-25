#Controller for activity
class ActivityController < ApplicationController
    def index
        @acts=Activity.all
    end
    
    def new
        @act = Activity.new
        @act_types = ActivityType.all
    end
    
    def act_params
        params.require(:activities).permit("name","duration","user")
    end
    
    def create
        @act = Activity.create(act_params)
        
        if @act.save
            redirect_to :action => 'index'
        else
            redirect_to :action => 'new'
        end
    end
    
    
end