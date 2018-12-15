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
    
    def RatingColor
        if(self.rating == 0)
           return "<span id=\"fpScore#{self.id}\">#{self.rating}</span>"
        end
        if(self.rating > 0)
            return "<span id=\"fpScore#{self.id}\" class=\"green-link\">#{self.rating}</span>"
        end
        if(self.rating < 0)
            return "<span id=\"fpScore#{self.id}\" class=\"red-link\">#{self.rating}</span>"
        end
        
        
    end
    def getOTP
        #Get one-true-parent
        if self.parentID == nil
            return self
        else
            return ForumPost.find(self.parentID).getOTP
        end
    end
    def isOTP
        return self.getOTP.id == self.id
    end
    def isAChildOf(parentID)
        if self.parentID == nil
            return false
        elsif self.parentID == parentID
            return true
        else
            return ForumPost.find(self.parentID).isAChildOf(parentID)
        end
    end
    def getElementContainer(user, depth=0)
        self.calculateRating
        @vote = user.hasVotedOn(self.id)
        @d = 20*depth
        if 20*depth > 100
            @d = 100
        end
        if (depth % 2 == 1)
            el = "<div class=\"bg-reply-color\" style=\"padding-left: #{@d}px; padding-right: #{@d}px;\">"
        elsif depth == 0
            el = "<div class=\"bg-light\" style=\"padding-left: #{@d}px; padding-right: #{@d}px;\">"
        else
            el = "<div class=\"bg-light\" style=\"padding-left: #{@d}px; padding-right: #{@d}px;\">"
        end
        el += "<div class=\"row\">"
        el += "<div class=\"col-2\">"
        el += "<div class=\"text-center\">"
        el += "<div class=\"d-inline-block\">"
        unless @vote==nil or @vote.thumbsUp==false
            el += "<a href=\"javascript:void(0)\" id=\"thumbsUp#{self.id}\" class=\"fa fa-thumbs-up green-link\" onclick=\"vote(#{self.id},true)\"></a>"
            
        else
            el += "<a href=\"javascript:void(0)\" id=\"thumbsUp#{self.id}\" class=\"fa fa-thumbs-up green-link-faded\" onclick=\"vote(#{self.id},true)\"></a>"
            
        end
        el += "</div>"
        if(depth % 2 == 1)
            #this is the secondary thumb color
            el += "<div class=\"d-inline-block text-dark\" style=\"padding-left: 20px; padding-right: 20px;\">"
        else
            el += "<div class=\"d-inline-block\" style=\"padding-left: 20px; padding-right: 20px;\">"
        end
        self.calculateRating
        el += "<span id=\"fpScore#{self.id}\">#{self.rating}</span>"
        el += "</div>"
        el += "<div class=\"d-inline-block\">"
        unless @vote==nil or @vote.thumbsUp
            el += "<a href=\"javascript:void(0)\" id=\"thumbsDown#{self.id}\" class=\"fa fa-thumbs-down red-link\" onclick=\"vote(#{self.id},false)\"></a>"
            
        else
            el += "<a href=\"javascript:void(0)\" id=\"thumbsDown#{self.id}\" class=\"fa fa-thumbs-down red-link-faded\" onclick=\"vote(#{self.id},false)\"></a>"
        
        end
        
        el += "</div>"
        el += "</div>"
        el += "</div>"
        if(depth % 2 == 1)
            el += "<div class=\"col-8 text-dark\">"
            
        else
            el += "<div class=\"col-8\">"
        end
        el += "<p>#{self.message}</p>"
        el += "</div>"
        if(depth % 2 == 1)
            el += "<div class=\"col-2 text-dark text-right\">"
            
        else
            el += "<div class=\"col-2 text-right\">"
        end
        el += "<a href=\"/profile/show?id=#{self.getUser().id}\">#{self.getUser().full_name}&nbsp&nbsp</a>"
        el += "</div>"
        el += "</div>"
        el += "<div class=\"row\">"
        el += "<div class=\"col-6 text-left\">"
        if user.id == self.creatorID
            el += "<a class=\"red-link\" href=\"\\forum_post\\delete?id=#{self.id}\" data-confirm=\"Are you sure you want to delete this post?\" data-method=\"delete\" rel=\"nofollow\">Delete&nbsp&nbsp</a>"
        end
        el += "</div>"
        el += "<div class=\"col-6 text-right\">"
        el += "<a href=\"#addNewPostModal\" class=\"blue-link\" onclick=\"changeHiddenParentID(#{self.id})\" data-toggle=\"modal\">Reply&nbsp&nbsp</a>"
        el += "</div>"
        el += "</div>"
        
        ForumPost.all.each {|post|
            if post.parentID==self.id
                el += post.getElementContainer(user, depth+1)
            end
        }
        el += "</div>"
        return el
    end
end
