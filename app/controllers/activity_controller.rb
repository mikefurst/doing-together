#Controller for activity
class ActivityController < ApplicationController
    def index
        @acts=Activity.all
    end
    
    def new
        @act = Activity.new
        @act_types = ActivityType.all.sort{ |a,b| a[:name]<=>b[:name] }
    end
    
    def show
        @act = Activity.find(params[:id])
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
    
    def edit
        @act = Activity.find(params[:id])
    end
    
    def delete
        Activity.find(params[:id]).destroy
        redirect_to :action => 'index'
    end
    
    
end