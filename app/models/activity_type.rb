class ActivityType < ActiveRecord::Base
    validates :name,
        presence: true,
        length: 5..50,
        on: :create,
        allow_nil: false
        
    validates :score,
        presence: true,
        on: :create,
        allow_nil: false
        
    def getActivityTypeJSON(current_user)
        return {
            :id => self.id,
            :name => self.name,
            :modifier => self.score,
            :verified => self.verified,
            :groupAdmin => (current_user.isAdmin and current_user.groupid==self.groupid),
            :selfOwned => (current_user.groupid==nil and self.userid == current_user.id)
        }
    end
end
