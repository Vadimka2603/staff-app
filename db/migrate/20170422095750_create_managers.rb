class CreateManagers < ActiveRecord::Migration[5.0]
  def change
    create_table :managers do |t|
      t.string :name
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
