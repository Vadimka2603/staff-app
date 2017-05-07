class AddPrepaymentLimitToWaiters < ActiveRecord::Migration[5.0]
  def change
    add_column :waiters, :prepayment_limit, :integer
  end
end
