class CreateWaiters < ActiveRecord::Migration[5.0]
  def change
    create_table :waiters do |t|
      t.string :name
      t.string :rank
      t.string :selfrate
      t.string :clientrate
      t.string :hotelrate

      t.timestamps
    end
  end
end
