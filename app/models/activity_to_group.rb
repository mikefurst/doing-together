class ActivityToGroup < ApplicationRecord
    def getActivity
        return Activity.find(self.actid)
    end
    def getGroup
        return Group.find(self.groupid)
    end
end
