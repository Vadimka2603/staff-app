class AddAddressToWaiters < ActiveRecord::Migration[5.0]
  def change
  	add_column :waiters, :address, :string
  end
end
