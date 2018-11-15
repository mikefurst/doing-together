# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


=begin
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
=end
first_names = [
    'James', 'John', 'Robert', 'Michael', 'William', 'David', 'Richard', 'Charles', 'Joseph', 'Thomas', 'Christopher', 'Daniel', 'Paul', 'Mark', 'Donald', 'George', 'Kenneth', 'Steven', 'Edward', 'Brian', 'Ronald', 'Anthony', 'Kevin', 'Jason', 'Matthew', 'Gary', 'Timothy', 'Jose', 'Larry', 'Jeffrey', 'Frank', 'Scott', 'Eric', 'Stephen', 'Andrew', 'Raymond', 'Gregory', 'Joshua', 'Jerry', 'Dennis', 'Walter', 'Patrick', 'Peter', 'Harold', 'Douglas', 'Henry', 'Carl', 'Arthur', 'Ryan', 'Roger', 'Joe', 'Juan', 'Jack', 'Albert', 'Jonathan', 'Justin', 'Terry', 'Gerald', 'Keith', 'Samuel', 'Willie', 'Ralph', 'Lawrence', 'Nicholas', 'Roy', 'Benjamin', 'Bruce', 'Brandon', 'Adam', 'Harry', 'Fred', 'Wayne', 'Billy', 'Steve', 'Louis', 'Jeremy', 'Aaron', 'Randy', 'Howard', 'Eugene', 'Carlos', 'Russell', 'Bobby', 'Victor', 'Martin', 'Ernest', 'Phillip', 'Todd', 'Jesse', 'Craig', 'Alan', 'Shawn', 'Clarence', 'Sean', 'Philip', 'Chris', 'Johnny', 'Earl', 'Jimmy', 'Antonio', 'Mary', 'Patricia', 'Linda', 'Barbara', 'Elizabeth', 'Jennifer', 'Maria', 'Susan', 'Margaret', 'Dorothy', 'Lisa', 'Nancy', 'Karen', 'Betty', 'Helen', 'Sandra', 'Donna', 'Carol', 'Ruth', 'Sharon', 'Michelle', 'Laura', 'Sarah', 'Kimberly', 'Deborah', 'Jessica', 'Shirley', 'Cynthia', 'Angela', 'Melissa', 'Brenda', 'Amy', 'Anna', 'Rebecca', 'Virginia', 'Kathleen', 'Pamela', 'Martha', 'Debra', 'Amanda', 'Stephanie', 'Carolyn', 'Christine', 'Marie', 'Janet', 'Catherine', 'Frances', 'Ann', 'Joyce', 'Diane', 'Alice', 'Julie', 'Heather', 'Teresa', 'Doris', 'Gloria', 'Evelyn', 'Jean', 'Cheryl', 'Mildred', 'Katherine', 'Joan', 'Ashley', 'Judith', 'Rose', 'Janice', 'Kelly', 'Nicole', 'Judy', 'Christina', 'Kathy', 'Theresa', 'Beverly', 'Denise', 'Tammy', 'Irene', 'Jane', 'Lori', 'Rachel', 'Marilyn', 'Andrea', 'Kathryn', 'Louise', 'Sara', 'Anne', 'Jacqueline', 'Wanda', 'Bonnie', 'Julia', 'Ruby', 'Lois', 'Tina', 'Phyllis', 'Norma', 'Paula', 'Diana', 'Annie', 'Lillian', 'Emily', 'Robin'
    ]
last_names = [
    'Smith', 'Johnson', 'Williams', 'Jones', 'Brown', 'Davis', 'Miller', 'Wilson', 'Moore', 'Taylor', 'Anderson', 'Thomas', 'Jackson', 'White', 'Harris', 'Martin', 'Thompson', 'Garcia', 'Martinez', 'Robinson', 'Clark', 'Rodriguez', 'Lewis', 'Lee', 'Walker', 'Hall', 'Allen', 'Young', 'Hernandez', 'King', 'Wright', 'Lopez', 'Hill', 'Scott', 'Green', 'Adams', 'Baker', 'Gonzalez', 'Nelson', 'Carter', 'Mitchell', 'Perez', 'Roberts', 'Turner', 'Phillips', 'Campbell', 'Parker', 'Evans', 'Edwards', 'Collins', 'Stewart', 'Sanchez', 'Morris', 'Rogers', 'Reed', 'Cook', 'Morgan', 'Bell', 'Murphy', 'Bailey', 'Rivera', 'Cooper', 'Richardson', 'Cox', 'Howard', 'Ward', 'Torres', 'Peterson', 'Gray', 'Ramirez', 'James', 'Watson', 'Brooks', 'Kelly', 'Sanders', 'Price', 'Bennett', 'Wood', 'Barnes', 'Ross', 'Henderson', 'Coleman', 'Jenkins', 'Perry', 'Powell', 'Long', 'Patterson', 'Hughes', 'Flores', 'Washington', 'Butler', 'Simmons', 'Foster', 'Gonzales', 'Bryant', 'Alexander', 'Russell', 'Griffin', 'Diaz', 'Hayes'
    ]
    
group_adjectives = [
    'Super', 'Amazing', 'Athletic', 'Joyful', 'Realistic', 'Expert', 'Stupendous', 'Bold', 'Bashful', 'Clever', 'Brainy', 'Elderly'
    ]
group_nouns = [
    'Runners', 'Athletes', 'Pirates', 'Scholars', 'Students', 'Professionals', 'Coders', 'Astronauts', 'Retirees'
    ]
activitytypelist = [
{
    :name => "Walking",
    :score => 1
},
{
    :name => "Jogging",
    :score => 1.25
},
{
    :name => "Running",
    :score => 1.50
},
{
    :name => "Swimming",
    :score => 1.75
},
{
    :name => "Martial Arts",
    :score => 2.00
}
]  
(1..10).each {
    @group = Group.create()
    @group.name = group_adjectives[rand(0..(group_adjectives.length-1))] << " " << group_nouns[rand(0..(group_nouns.length-1))]
    @group.description = "A group for " << @group.name << " to do stuff together."
    @group.password = "Password"
    @group.save!
    r = rand(10..15)
    userids = []
    actids = []
    (1..r).each {
        first_name = nil
        while first_name==nil do
            first_name = first_names[rand(0..(first_names.length-1))]
        end
        last_name = nil
        while last_name==nil do
            last_name = last_names[rand(0..(last_names.length))]
        end
        email = first_name[0] << last_name << rand(11..1111).to_s()<< "@dotgthr.com"
        @user = User.create(:first_name => first_name, :last_name => last_name, :email => email, :password => 'Password')
        @user.groupid = @group.id
        @user.save!
        userids.push(@user.id)
    }
    activitytypelist.each { |atype|
        @act = ActivityType.create(atype)
        @act.groupid = @group.id
        @act.verified = true
        @act.save!
        actids.push(@act.id)
    }
    r = rand(100..200)
    (1..r).each {
        @act = Activity.create()
        while @act.actid == nil
            @act.actid = actids[rand(0..(actids.length-1))]
        end
        while @act.userid == nil
            @act.userid = userids[rand(0..(userids.length-1))]
        end
        @act.duration = rand(100..3000)/100.0
        @act.save!
    }
}
#Create some empty users to test adding a member to a group
r = rand(10..15)
(1..r).each {
    first_name = nil
    while first_name==nil do
        first_name = first_names[rand(0..(first_names.length-1))]
    end
    last_name = nil
    while last_name==nil do
        last_name = last_names[rand(0..(last_names.length))]
    end
    email = first_name[0] << last_name << rand(111..11111).to_s()<< "@dotgthr.com"
    @user = User.create(:first_name => first_name, :last_name => last_name, :email => email, :password => 'Password')
    @user.save!
}