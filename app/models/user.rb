class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  def full_name
    return self.first_name << " " << self.last_name
  end
  def score
    @score=0
    Activity.all.each { |act|
      if act.userid==self.id
        @score += act.duration * ActivityType.find(act.actid).score
      end
    }
    return @score
  end
end
