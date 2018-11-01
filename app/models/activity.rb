class Activity < ActiveRecord::Base
    def groupid
        return ActivityType.find(self.actid).groupid
    end
    def name
        return ActivityType.find(self.actid).name
    end
    def userName
        return User.find(self.userid).full_name
    end
    def updated
        return self.updated_at > self.created_at
    end
    def getNewActivityJSON(current_userID=nil)
        return {
            :id => self.id,
            :name => self.name,
            :userName => self.userName,
            :duration => self.duration,
            :created_at => self.created_at,
            :timestamp => self.created_at.in_time_zone("Central Time (US & Canada)").strftime("%H:%M"),
            :datestamp => self.created_at.in_time_zone("Central Time (US & Canada)").strftime("%a, %m/%d/%y"),
            :current_user => (self.userid == current_userID)
        }
    end
    def getActivityJSON(current_userID=nil)
        return {
            :id => self.id,
            :name => self.name,
            :userName => self.userName,
            :duration => self.duration,
            :updated => self.updated,
            :created_at => self.created_at,
            :timestamp => self.created_at.in_time_zone("Central Time (US & Canada)").strftime("%H:%M"),
            :datestamp => self.created_at.in_time_zone("Central Time (US & Canada)").strftime("%A, %m/%d/%y"),
            :timestamp_u => self.created_at.in_time_zone("Central Time (US & Canada)").strftime("%H:%M"),
            :datestamp_u => self.created_at.in_time_zone("Central Time (US & Canada)").strftime("%A, %m/%d/%y"),
            :current_user => (self.userid == current_userID)
        }
    end
end