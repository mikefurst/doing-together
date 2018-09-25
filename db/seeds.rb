# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#list of test activities to seed to the activity db
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
    },
    {
        :name => "Jamesing",
        :duration => 40,
        :user => "James Terrio"
    },
    {
        :name => "Fornicating",
        :duration => 100,
        :user => "How bout dat girl"
    }
    ]
    
#add all the db
activity_list.each do |act|
    Activity.create!(act)
end

activity_types = [
    {
        :name => "Walking",
        :score => 1
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
        :name => "Fornicating",
        :score => 1.33
    },
    {
        :name => "Jamesing",
        :score => -5.0
    },
    {
        :name => "Cycling",
        :score => 3.0
    }
    ]
    
activity_types.each do |act|
    ActivityType.create!(act)
end