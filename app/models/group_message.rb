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
    def timeAsInt
        return self.created_at.strftime("%s")
    end
    def getNewMessageJSON(current_userID=nil)
        return {
            :id => self.id,
            :message => self.message,
            :userName => self.userName,
            :created_at => self.created_at,
            :timestamp => self.getTimeStamp,
            :datestamp => self.getDateStamp,
            :current_user => (self.userid == current_userID)
        }
    end
end
