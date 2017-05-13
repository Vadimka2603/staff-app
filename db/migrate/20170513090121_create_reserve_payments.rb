class CreateReservePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :reserve_payments do |t|
      t.integer :waiter_id
      t.integer :shift_id
      t.boolean :active, default: false
      t.float :client_rate
      t.float :self_rate
      t.boolean :paid, default: false

      t.timestamps
    end
  end
end
