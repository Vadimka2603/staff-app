class AddCostToPayments < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :cost, :integer
  end
end
