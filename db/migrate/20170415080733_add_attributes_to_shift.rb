class AddAttributesToShift < ActiveRecord::Migration[5.0]
  def change
     add_column :shifts, :is_main, :boolean, default: false
     add_column :shifts, :is_coordinator, :boolean, default: false
     add_column :shifts, :is_reserve, :boolean, default: false
  end
end
