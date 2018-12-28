class CreateActivityToUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :activity_to_users do |t|
      t.integer :actid
      t.integer :userid
    end
  end
end
