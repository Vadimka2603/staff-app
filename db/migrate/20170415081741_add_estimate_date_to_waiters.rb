class AddEstimateDateToWaiters < ActiveRecord::Migration[5.0]
  def change
    add_column :waiters, :estimate_date, :date
  end
end
