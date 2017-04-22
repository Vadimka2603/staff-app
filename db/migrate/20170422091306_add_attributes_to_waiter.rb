class AddAttributesToWaiter < ActiveRecord::Migration[5.0]
  def change
  	  add_column :waiters, :birthday, :date
      add_column :waiters, :passport_number, :integer
      add_column :waiters, :passport_seria, :integer
      add_column :waiters, :health_book, :boolean, default: true
      add_column :waiters, :health_book_estimate, :date
      add_column :waiters, :manager_id, :integer
      add_column :waiters, :gender, :string
  end
end
