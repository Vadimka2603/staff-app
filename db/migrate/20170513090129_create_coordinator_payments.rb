class CreateCoordinatorPayments < ActiveRecord::Migration[5.0]
  def change
    create_table :coordinator_payments do |t|
      t.integer :waiter_id
      t.integer :shift_id

      t.float :client_rate
      t.float :self_rate
      t.boolean :paid, default: false

      t.timestamps
    end
  end
end
