class ActivityTypeController < ApplicationController
    def index
        @actTypes = ActivityTypes.all
    end
end
