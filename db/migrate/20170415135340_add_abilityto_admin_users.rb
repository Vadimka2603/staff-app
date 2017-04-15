class AddAbilitytoAdminUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :admin_users, :ability, :boolean, default: true
  end
end
