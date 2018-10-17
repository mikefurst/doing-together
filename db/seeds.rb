# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#list of test activities to seed to the activity db
=begin
activity_list = [
    {
        :name => "Walking",
        :duration => 10,
        :user => "Samuel L. Jackson"
    },
    {
        :name => "Running",
        :duration => 30,
        :user => "Michael Fitzgerald"
    },
    {
        :name => "Jogging",
        :duration => 25,
        :user => "Sam Wilson"
    },
    {
        :name => "Jumping Jacks",
        :duration => 40,
        :user => "Wilson Smith"
    },
    {
        :name => "Jogging",
        :duration => 5,
        :user => "James Terrio"
    }
    ]
    
#add all the db
activity_list.each do |act|
    Activity.create!(act)
end

activity_types = [
  {
      :name => "Cycling",
      :score => 3.0
  },
  {
      :name => "Jogging",
      :score => 1.5
  },
  {
      :name => "Jumping Jacks",
      :score => 1.2
  },
  {
      :name => "Running",
      :score => 2.0
  },
  {
      :name => "Swimming",
      :score => 2.0
  },
  {
      :name => "Walking",
      :score => 1
  }
  
  ]
activity_types.each do |act|
  ActivityType.create!(act)
end
=end

@group = Group.create()
@group.name = "Pirates of the Carribean"
@group.description = "Swashbucklers of the Carribean. Seeking out legendary treasure. Train with us to become a pirate."
@group.password = "Yohohoandabottleofrum"
@group.save!

user_list = [
    {
        :first_name => "Jack",
        :last_name => "Sparrow",
        :email => "jsparrow@theblackpearl.com",
        :password => "JohnnyDepp",
    },
    {
        :first_name => "Will",
        :last_name => "Turner",
        :email => "wturner@theblackpearl.com",
        :password => "OrlandoBloom",
    },
    {
        :first_name => "Elizabeth",
        :last_name => "Swan",
        :email => "eswan@theblackpearl.com",
        :password => "KieraKnightley",
    },
    {
        :first_name => "Hector",
        :last_name => "Barbosa",
        :email => "hbarbosa@theblackpearl.com",
        :password => "GeoffreyRush",
    }
    ]
    
userids = Array.new
user_list.each do |usr|
    @user = User.create(usr)
    @user.groupid=@group.id
    @user.save!
    userids.push(@user.id)
end
@group.adminid=1
@group.save!

activitytypelist = [
    {
        :name => "Swimming",
        :score => 2.125,
    },
    {
        :name => "Swashbuckling",
        :score => 1.15,
    },
    {
        :name => "Fencing",
        :score => 1.85,
    },
    {
        :name => "Scrubbing the Deck",
        :score => 1.56,
    },
    {
        :name => "Hoisting the Sails",
        :score => 1.35,
    },
    {
        :name => "Stealing from the Spanish",
        :score => 4.00,
    }
    ]
    
acttypeids = Array.new
activitytypelist.each do |atype|
    @act = ActivityType.create(atype)
    @act.groupid = @group.id
    @act.verified = true
    @act.save!
    acttypeids.push(@act.id)
end

acttypeids.each do |actid|
    userids.each do |id|
        @a = Activity.create()
        @a.actid = actid
        @a.duration=(id+1)+(actid+1)*1.75
        @a.userid = id
        @a.save!
    end
end