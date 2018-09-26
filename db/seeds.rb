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
    }
    ]
    
#add all the db
activity_list.each do |act|
    Activity.create!(act)
end