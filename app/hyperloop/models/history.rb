require 'models/application_record'
class History < ApplicationRecord
  belongs_to :valve

  # Create an instance of History, using valve_id of the owning Valve as initialization parameter
  def self.start(valve)
    History.create(start_time: Time.now, valve_id: valve.id)
  end

  # Complete the history
  def stop
    update(stop_time: Time.now)
  end

end
