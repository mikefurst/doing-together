class Remove < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :groupid, :integer
  end
end
