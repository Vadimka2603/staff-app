class SetDefaultToFalse < ActiveRecord::Migration[5.0]
  def change
  	change_column :waiters, :health_book, :boolean, default: false
  end
end
