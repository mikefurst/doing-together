class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :postID
      t.integer :creatorID
      t.boolean :thumbsUp
      t.timestamps
    end
  end
end
