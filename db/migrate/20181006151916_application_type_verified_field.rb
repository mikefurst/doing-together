class ApplicationTypeVerifiedField < ActiveRecord::Migration[5.0]
  def change
    add_column :activity_types, :verified, :boolean
  end
end
