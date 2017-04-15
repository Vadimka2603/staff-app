class FoxRates < ActiveRecord::Migration[5.0]
  def change
  	remove_column :waiters, :selfrate, :string
  	remove_column :waiters, :clientrate, :string
  	remove_column :waiters, :hotelrate, :string
  	add_column :shifts, :selfrate, :float
  	add_column :shifts, :clientrate, :float
  	add_column :shifts, :hotelrate, :float
  	add_column :shifts, :date, :date
  	remove_column :shifts, :start_date, :date
  	remove_column :shifts, :finish_date, :date
  	add_column :shifts, :start_time, :time
  	add_column :shifts, :finish_time, :time
  end
end
