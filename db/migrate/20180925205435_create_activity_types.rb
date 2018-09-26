class CreateActivityTypes < ActiveRecord::Migration
  def change
    create_table :activity_types do |t|
      t.string :name
      t.float :score
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
  end
end
