class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates :first_name,
    presence: true,
    on: :create,
    allow_nil: false
    
  validates :last_name,
    presence: true,
    on: :create,
    allow_nil: false
    
  validates :email,
    presence: true,
    on: :create,
    allow_nil: false
    
  def full_name
    return self.first_name << " " << self.last_name
  end
  
  def score
    @score=0
    Activity.all.each { |act|
      if act.userid==self.id
        if self.groupid==nil
          if ActivityType.find(act.actid).userid==self.id
            @score += act.duration * ActivityType.find(act.actid).score
          end
        elsif self.groupid==ActivityType.find(act.actid).groupid
          @score += act.duration * ActivityType.find(act.actid).score
        end
      end
    }
    return @score.round(4)
  end
  
  def lastActivity
    @act = nil
    
    @acts = Activity.all.select { |ac|
      ac.userid == self.id
    }
    
    if @acts.blank?
      return nil
    end
    
    if self.groupid == nil
      @acts = @acts.select { |ac|
        ac.groupid == nil
      }
    else
      @acts = @acts.select { |ac|
        ac.groupid == self.groupid
      }
    end
    
    if @acts.blank?
      return nil
    end
    
    @acts = @acts.sort { |a,b| b.created_at <=> a.created_at}
    @act = @acts[0]
    return @act
  end
  
  def isAdmin
    if self.groupid==nil
      return false
    end
    return Group.find(self.groupid).adminid == self.id
  end
  
end
