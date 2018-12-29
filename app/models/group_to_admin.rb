class GroupToAdmin < ApplicationRecord
    def getGroup()
        return Group.find(self.groupid)
    end
    def getUser()
        return Group.find(self.userid)
    end
    def getAdmin()
        return self.getUser()
    end
end
