class CreateSprinkles < ActiveRecord::Migration[5.1]
  def change
    create_table :sprinkles do |t|
      t.datetime :next_start_time
      t.datetime :base_start_time
      t.string :time_input
      t.integer :duration
      t.integer :valve_id

      t.timestamps
    end
  end
end
