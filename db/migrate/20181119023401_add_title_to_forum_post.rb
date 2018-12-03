class AddTitleToForumPost < ActiveRecord::Migration[5.0]
  def change
    add_column :forum_posts, :title, :string
  end
end
