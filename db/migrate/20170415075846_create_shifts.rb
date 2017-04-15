class CreateShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :shifts do |t|
      t.datetime :start_date
      t.datetime :finish_date
      t.string :rank
      t.integer :waiter_id

      t.timestamps
    end
  end
end
