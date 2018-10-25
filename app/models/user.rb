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
end
