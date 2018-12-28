class ActivityTypeToGroup < ApplicationRecord
    def getActivityType()
        return ActivityType.find(self.actid)
    end
    def getGroup()
        return Group.find(self.groupid)
    end
end
