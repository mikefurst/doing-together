class ActivityTypeController < ApplicationController
    def index
        @actTypes = ActivityType.all.sort{ |a,b| a[:name]<=>b[:name] }
    end
    def new
        @actType = ActivityType.new
        @actTypes = ActivityType.all.sort{ |a,b| a[:name]<=>b[:name] }
    end
    def acttype_params
        params.require(:activitytypes).permit("name","score")
    end
    def create
        @actType = ActivityType.create(acttype_params)
        
        if @actType.save
            redirect_to :action => 'index'
        else
            redirect_to :action => 'new'
        end
    end
    def edit
        @actType = ActivityType.find(params[:id])
    end
    def acttype_param
        params.require(:activity_type).permit('name','score')
    end
    def update
        @actType = ActivityType.find(params[:id])
        
        if @actType.update_attributes(acttype_param)
            redirect_to :action => 'index'
        else
            redirect_to :action => 'edit'
        end
    end
end
