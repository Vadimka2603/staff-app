class AddActiveToPayments < ActiveRecord::Migration[5.0]
  def change
  	add_column :payments, :active, :boolean, default: false
  end
end
