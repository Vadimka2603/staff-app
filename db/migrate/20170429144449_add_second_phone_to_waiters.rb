class AddSecondPhoneToWaiters < ActiveRecord::Migration[5.0]
  def change
    add_column :waiters, :second_phone, :string
  end
end
