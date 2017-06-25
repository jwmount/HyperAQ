class CreateSprinkleEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :sprinkle_events do |t|
      t.integer :sprinkle_id
      t.integer :valve_id
      t.integer :history_id

      t.timestamps
    end
  end
end
