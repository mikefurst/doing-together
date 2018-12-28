class ActivityTypeToUser < ApplicationRecord
    def getActivityType()
        return ActivityType.find(self.actid)
    end
    def getUser()
        return User.find(self.userid)
    end
end
