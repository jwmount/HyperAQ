class CreateCrontabActuators < ActiveRecord::Migration[5.1]
  def change
    create_table :crontab_actuators do |t|
      t.string :state

      t.timestamps
    end
  end
end
