class AddGroupInviteFlagCreator < ActiveRecord::Migration[5.0]
  def change
    add_column :group_invites, :creatorID, :integer
  end
end
