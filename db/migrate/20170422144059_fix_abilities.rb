class FixAbilities < ActiveRecord::Migration[5.0]
  def change
  	remove_column :admin_users, :ability, :boolean, default: true
  	add_column :admin_users, :ability, :boolean, default: false
  end
end
