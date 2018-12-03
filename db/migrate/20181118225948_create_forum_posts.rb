class CreateForumPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :forum_posts do |t|
      t.integer :creatorID
      t.string :message
      t.integer :groupID
      t.integer :parentID
      t.integer :rating
      t.timestamps
    end
  end
end
