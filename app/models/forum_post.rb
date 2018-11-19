class ForumPost < ApplicationRecord
    def getUser
        return User.find(self.creatorID)
    end
    def calculateRating
        votes = 0
        Vote.all.each {|v|
            if v.postID == self.id
                if v.thumbsUp
                    votes += 1
                else
                    votes -= 1
                end
            end
        }
        self.rating = votes
        self.save
    end
    def getOTP
        #Get one-true-parent
        if self.parentID == nil
            return self
        else
            return ForumPost.find(self.parentID).getOTP
        end
    end
end
