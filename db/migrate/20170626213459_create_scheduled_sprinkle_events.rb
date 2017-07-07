class CreateScheduledSprinkleEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :scheduled_sprinkle_events do |t|
      t.integer :sprinkle_id
      t.integer :valve_id
      t.integer :history_id
      t.integer :valve_cmd

      t.timestamps
    end
  end
end
