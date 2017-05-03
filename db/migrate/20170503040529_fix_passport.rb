class FixPassport < ActiveRecord::Migration[5.0]
  def change
  	  remove_column :waiters, :passport_number, :integer
      remove_column :waiters, :passport_seria, :integer
      add_column :waiters, :passport_number, :string
  end
end
