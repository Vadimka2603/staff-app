class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.integer :waiter_id
      t.integer :shift_id
      
      t.timestamps
    end
  end
end
