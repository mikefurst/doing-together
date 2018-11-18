class AddGroupInviteFlagFor < ActiveRecord::Migration[5.0]
  def change
    add_column :group_invites, :toJoin, :boolean
  end
end
