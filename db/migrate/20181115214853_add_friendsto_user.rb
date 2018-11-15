class AddFriendstoUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :friends, :integer, array: true, default: []
  end
end
