require 'models/application_record'
class Porter < ApplicationRecord

  if RUBY_ENGINE != 'opal'
    def manipulate_and_update(params, request)
      # hack used to build a hostname:port for use with ScheduledSprinkleEvents callbacks from crontab
      porter = Porter.first
      porter.host_name = `hostname`.strip
      porter.port_number = request.port
      porter.save
      w = WaterManager.first
      w.http_host = "#{porter.host_name}:#{porter.port_number}"
      w.save
      update(params)
    end
  end
  
end
