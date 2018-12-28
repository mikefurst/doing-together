class CreateActivityToGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :activity_to_groups do |t|
      t.integer :actid
      t.integer :groupid
    end
  end
end
