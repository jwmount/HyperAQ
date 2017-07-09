class CreateValveActuators < ActiveRecord::Migration[5.1]
  def change
    create_table :valve_actuators do |t|
      t.integer :valve_id
      t.integer :cmd

      t.timestamps
    end
  end
end
