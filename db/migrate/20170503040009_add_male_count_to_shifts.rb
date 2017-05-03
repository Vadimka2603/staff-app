class AddMaleCountToShifts < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :male_count, :integer
  end
end
