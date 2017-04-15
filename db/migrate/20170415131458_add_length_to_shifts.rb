class AddLengthToShifts < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :length, :float
  end
end
