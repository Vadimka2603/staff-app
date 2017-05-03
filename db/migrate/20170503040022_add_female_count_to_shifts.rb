class AddFemaleCountToShifts < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :female_count, :integer
  end
end
