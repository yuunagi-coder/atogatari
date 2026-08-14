class CreateRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :records do |t|
      t.string :spot_name, null: false
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7
      t.datetime :recorded_at
      t.text :memo
      t.references :user, null: false, foreign_key: true

      t.timestamps
      t.index :spot_name
      t.index [:latitude, :longitude]
    end
  end
end
