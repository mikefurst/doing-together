class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers=> [:facebook, :google_oauth2]
         
         
	has_many :friendships,   dependent: :destroy
	has_many :received_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy

  has_many :passive_friends, -> { where(friendships: { accepted: true}) }, through: :received_friendships, source: :user
  has_many :active_friends, -> { where(friendships: { accepted: true}) }, :through => :friendships, :source => :friend
  has_many :requested_friendships, -> { where(friendships: { accepted: false}) }, through: :received_friendships, source: :user
  has_many :pending_friends, -> { where(friendships: { accepted: false}) }, :through => :friendships, :source => :friend

	def friends
	  active_friends | received_friends
	end

	def pending
		pending_friends | requested_friendships
	end

         
  acts_as_messageable
         
  serialize :friends
  
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
  
  def mailboxer_email(object)
    nil
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
  
  def groupName
    if self.groupid==nil
      return nil
    else
      return Group.find(self.groupid).name
    end
  end
  def isAdmin
    if self.groupid==nil
      return false
    end
    return Group.find(self.groupid).adminid == self.id
  end
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name   # assuming the user model has a name
      user.last_name = auth.info.last_name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
      return user
    end
  end
  
  def self.from_omniauthgoogle(auth)
    data = auth.info
    user = User.where(:email => data["email"]).first

    unless user
      password = Devise.friendly_token[0,20]
      user = User.create(:first_name => data[:first_name], :last_name => data[:last_name], :email => data["email"],
      :password => password, :password_confirmation => password)
    end
    return user
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  def hasInvite
    return GroupInvite.select{|grpInv| grpInv.targetID == self.id}.length > 0
  end
  def pendingInvite(grpId)
    return GroupInvite.select {|grpInv| grpInv.creatorID==self.id and grpInv.groupID == grpId}.length > 0
  end
  
  

	

end
