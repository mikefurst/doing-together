class ActivityToUser < ApplicationRecord
    def getActivity
        return Activity.find(self.actid)
    end
    def getUser
        return User.find(self.userid)
    end
end
