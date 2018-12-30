require 'bcrypt'
class Group < ApplicationRecord
    include BCrypt
    
    validates :name,
        presence: true,
        length: 10..50,
        on: :create,
        allow_nil: false
        
    validates :description,
        presence: true,
        length: 15..150,
        on: :create,
        allow_nil: false
    
    def password
        @password ||= Password.new(password_hash)
    end
    def password=(new_password)
        @password = Password.create(new_password)
        self.password_hash = @password
    end
    
    def numMembers
        @u2g = UserToGroup.select {|u|
            u.groupid == self.id
        }
        return @u2g.length
    end
    
    def getAdmins()
        @admins = Array.new
        GroupToAdmin.all.each {|g|
            if g.groupid == self.id
                @admins.push(g.getUser())
            end
        }
        return @admins
    end
    
    def getOwner()
        checkAdmins()
        @g2a = GroupToAdmin.select {|g|
            g.groupid == self.id
        }
        return @g2a.sort{|a,b| a.created_at <=> b.created_at}[0]
    end
    
    def checkAdmins()
        @g2a = GroupToAdmin.select {|g|
            g.groupid == self.id
        }
        if @g2a.length <= 0
            user = UserToGroup.select {|g|
                g.groupid == self.id
            }.sort{|a,b| a.created_at <=> b.created_at}[0]
            @g = GroupToAdmin.create(:groupid => self.id, :userid => user.userid)
            @g.save!
        end
    end
    
    def lastFivePosts
        @posts = ForumPost.select {|fp|
            (fp.groupID == self.id) and (fp.isOTP)
        }.sort {|a,b| b.created_at <=> a.created_at }[0..4]
    end
    
end
