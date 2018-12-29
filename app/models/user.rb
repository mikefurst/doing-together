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
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, -> { where(friendships: { accepted: true}) }, :through => :inverse_friendships, :source => :user

	def friends
	  active_friends | received_friendships
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
  def hasVotedOn(fPostId)
    @votes = Vote.select {|v|
      v.postID == fPostId and v.creatorID == self.id
    }
    return @votes.first
  end
  
  def isFriend(userID)
    if self.friends.include? User.find(userID) or self.pending_friends.include? User.find(userID)
      return true
    else
      return false
    end
  end
  
  def getGroups()
    @u2g = UserToGroup.select {|u|
      u.userid == self.id
    }
    @grps = Array.new
    @u2g.each {|u|
      @grps.push(u.getGroup())
    }
    return @grps
  end
  def inGroup(groupid)
    UserToGroup.all.each {|u|
      if u.userid == self.id and u.groupid == groupid
        return true
      end
    }
    return false
  end
  def score(grpid)
    @score=0
    
    @a2u = ActivityToUser.select {|a|
      a.userid == self.id
    }
    @acts = Array.new
    @a2u.each {|a|
      act = a.getActivity()
      if act.groupid == grpid
        acts.push(act)
      end
    }
    @acts.each {|act|
      scr = ActivityType.find(act.actid).score
      @score += act.duration * scr
    }
    return @score.round(4)
  end
  
  def lastActivity(grpid)
    @a2u = ActivityToUser.select {|a|
      a.userid == self.id
    }
    if @a2u.blank?
      return nil
    end
    @acts = Array.new
    @a2u.each {|a|
      act = a.getActivity()
      if act.groupid == grpid
        acts.push(act)
      end
    }
    @acts = @acts.sort { |a,b| b.created_at <=> a.created_at}
    @act = @acts[0]
    return @act
  end
  
  def getGroupNames
    @grps = self.getGroups()
    @names = Array.new
    @grps.each { |g|
      @names.push(g.name)
    }
    return @names
  end
  def isAdmin(groupid)
    @g2a = GroupToAdmin.select {|grp|
      g.groupid == groupid and g.userid == self.id
    }
    return @g2a.length >= 1
  end
end
