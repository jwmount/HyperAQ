class CreateWaterManagers < ActiveRecord::Migration[5.1]
  def change
    create_table :water_managers do |t|
      t.string :state
      t.string :http_host

      t.timestamps
    end
  end
end
