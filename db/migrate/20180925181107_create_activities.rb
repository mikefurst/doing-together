class CreateActivities < ActiveRecord::Migration
  def change
    #create activites table
    create_table :activities do |t|
      #name spot
      t.integer :actid
      #duration spot
      t.float :duration
      #username
      t.integer :userid
      #timestamp spot
      t.timestamps null: false
    end
  end
end
