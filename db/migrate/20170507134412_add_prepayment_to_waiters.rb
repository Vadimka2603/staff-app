class AddPrepaymentToWaiters < ActiveRecord::Migration[5.0]
  def change
    add_column :waiters, :prepayment, :integer
  end
end
