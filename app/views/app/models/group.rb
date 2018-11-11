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
        n = 0
        User.all.each {|user|
            if user.groupid == self.id
                n += 1
            end
        }
        return n
    end
    
end
