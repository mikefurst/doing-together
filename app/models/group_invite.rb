class GroupInvite < ApplicationRecord
    def makeJSON(current_userID=nil)
        if self.toJoin == nil
            self.toJoin = false
        end
        return {
            :id => self.id,
            :groupId => self.groupID,
            :groupName => Group.find(self.groupID).name,
            :targetId => self.targetID,
            :targetName => User.find(self.targetID).full_name,
            :message => self.message,
            :creatorID => self.creatorID,
            :creatorName => User.find(self.creatorID).full_name,
            :toJoin => self.toJoin
        }
    end
end
