require 'models/application_record'

class Valve < ApplicationRecord
  has_many :sprinkles
  has_many :histories 
 
  if RUBY_ENGINE != 'opal'
    require 'time'

    ON = 1
    OFF = 0

    # Sprinkle states
    NEXT = "Next"
    ACTIVE = "Active"
    IDLE = "Idle"

    LOGFILE = "log/valve.log"

    def log(msg)
      f = File.open(LOGFILE, 'a')
      f.write msg
      f.close
    end

    def manipulate_and_update(params, valve)
     # byebug
      
      log "\nvalve --> #{valve.name}\n"

      cmd = params['cmd'].to_i
      log "cmd --> #{cmd}\n"
      active_sprinkle_id = params['active_sprinkle_id'].to_i
      log "active_sprinkle_id --> #{active_sprinkle_id}\n"

      # byebug 
      
      if cmd == ON # start valve sequence

        sprinkle = Sprinkle.find(active_sprinkle_id)
        sprinkle.state = ACTIVE
        sprinkle.save
        log "change sprinkle(#{sprinkle.id}) state to #{sprinkle.state}\n"
        valve.active_sprinkle_id = sprinkle.id

        history = History.start(valve)
        valve.active_history_id = history.id
        log "created a new history @ #{history.start_time_display}\n"
        
        log "turn on Valve #{valve.name}\n"
        command(ON)

      else # stop valve sequence

        sprinkle = Sprinkle.find(valve.active_sprinkle_id)
        sprinkle.state = IDLE
        sprinkle.save
        log "change sprinkle(#{sprinkle.id}) state to #{sprinkle.state}\n"

        history = History.find(valve.active_history_id)
        history.stop
        log "update and save History(#{history.id}) @ #{history.stop_time_display}\n"

        log "turn off Valve #{valve.name}\n"
        command(OFF)

      end

      valve.save
    end

    # send command(s) to Raspberry PI GPIO pins (using WiringPI global shell command, gpio)
    def command(val)
      log "command(#{val})\n"
      mode = "gpio -g mode #{gpio_pin} out"
      write = "gpio -g write #{gpio_pin} #{val}"
      system(mode)
      system(write)
    end

    # answer a set of parameters needed by rest_client.rb
    def to_crontab(action)
      "%2d %2d" % [id, action] 
    end

  end # RUBY_ENGINE
end

