class CreateWaterManagers < ActiveRecord::Migration[5.1]
  def change
    create_table :water_managers do |t|
      t.string :state

      t.timestamps
    end
  end
end
