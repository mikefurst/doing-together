class AddUserPrivateFlag < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :isPrivate, :boolean
  end
end
