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
    
    after_create :registerToActivityTypetoGroup, :registerToActivityTypetoUser
        
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
    
    private
        def registerToActivityTypetoGroup()
            ActivityTypeToGroup.create(:actid => self.id, :groupid => self.groupid)
        end
        def registerToActivityTypetoUser()
            ActivityTypeToUser.create(:actid => self.id, :userid => self.userid)
        end
end
