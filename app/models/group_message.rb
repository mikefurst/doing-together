class GroupMessage < ApplicationRecord
    def userName
        return User.find(self.userid).full_name
    end
    def getTimeStamp
        return self.created_at.in_time_zone("Central Time (US & Canada)").strftime("%H:%M")
    end
    def getDateStamp
        return self.created_at.in_time_zone("Central Time (US & Canada)").strftime("%a, %m/%d/%y")
    end
end
