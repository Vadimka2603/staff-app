class AddAttributesToPayments < ActiveRecord::Migration[5.0]
  def change
  	add_column :payments, :client_rate, :float
    add_column :payments, :self_rate, :float
    remove_column :shifts, :is_main, :boolean, default: false
    remove_column :shifts, :is_coordinator, :boolean, default: false
    remove_column :shifts, :is_reserve, :boolean, default: false
    add_column :payments, :is_main, :boolean, default: false
    add_column :payments, :is_coordinator, :boolean, default: false
    add_column :payments, :is_reserve, :boolean, default: false
  end
end
