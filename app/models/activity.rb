class Activity < ActiveRecord::Base
    after_create :registerToActToGroup, :registerToActToUser
    
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
    def niceDuration
        hours = (self.duration / 60).floor
        rawMinutes = (self.duration - (hours*60))
        minutes = rawMinutes.floor
        seconds = ((rawMinutes-minutes)*60).round
        msg = ""
        if hours > 0
            if hours == 1
                msg+=hours.to_s + " hour"
            else
                msg+=hours.to_s + " hours"
            end
            if minutes > 0 and seconds > 0
                msg += ", "
            elsif minutes >0 or seconds > 0
                msg += " and "
            end
        end
        if minutes > 0
            if minutes == 1
                msg+=minutes.to_s + " minute"
            else
                msg+=minutes.to_s + " minutes"
            end
            if hours >0 and seconds >0
                msg += ", and "
            elsif seconds > 0
                msg += " and "
            end
        end
        if seconds > 0
            if seconds==1
                msg += seconds.to_s + " second"
            else
                msg += seconds.to_s + " seconds"
            end
        end
        return msg
    end
    def getNewActivityJSON(current_userID=nil)
        return {
            :id => self.id,
            :name => self.name,
            :userName => self.userName,
            :duration => self.duration,
            :full_duration => self.niceDuration,
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
            :full_duration => self.niceDuration,
            :updated => self.updated,
            :created_at => self.created_at,
            :timestamp => self.created_at.in_time_zone("Central Time (US & Canada)").strftime("%H:%M"),
            :datestamp => self.created_at.in_time_zone("Central Time (US & Canada)").strftime("%A, %m/%d/%y"),
            :timestamp_u => self.created_at.in_time_zone("Central Time (US & Canada)").strftime("%H:%M"),
            :datestamp_u => self.created_at.in_time_zone("Central Time (US & Canada)").strftime("%A, %m/%d/%y"),
            :current_user => (self.userid == current_userID)
        }
    end
    private
        def registerToActToGroup()
            @acttog = ActivityToGroup.create(:actid => self.id, :groupid => self.groupid)
            return
        end
        def registerToActToUser()
            @actotou = ActivityToUser.create(:actid => self.id, :userid => self.userid)
            return
        end
end