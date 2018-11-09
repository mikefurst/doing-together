class GroupInvite < ApplicationRecord
    def makeJSON(current_userID=nil)
        return {
            :id => self.id,
            :groupId => self.groupID,
            :groupName => Group.find(self.groupID).name,
            :targetId => self.targetID,
            :message => self.message
        }
    end
end
