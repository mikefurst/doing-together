class CreateCreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :create_groups do |t|
      t.string :author
      t.text :content

      t.timestamps
    end
  end
end
