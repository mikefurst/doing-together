class CreateCreatGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :creat_groups do |t|
      t.string :author
      t.text :content

      t.timestamps
    end
  end
end
