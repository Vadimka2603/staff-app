class AddWaitersCountToShifts < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :waiters_count, :integer
  end
end
