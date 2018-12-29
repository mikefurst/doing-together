class UserToGroup < ApplicationRecord
    def getUser()
        return User.find(self.userid)
    end
    def getGroup()
        return Group.find(self.groupid)
    end
end
