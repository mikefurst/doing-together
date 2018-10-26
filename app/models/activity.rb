class Activity < ActiveRecord::Base
    def groupid
        return ActivityType.find(self.actid).groupid
    end
    def name
        return ActivityType.find(self.actid).name
    end
end
