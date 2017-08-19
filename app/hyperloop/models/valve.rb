require 'models/application_record'

class Valve < ApplicationRecord
  has_many :sprinkles
  has_many :histories 

  # attr_accessor :active_sprinkle_id
  # attr_accessor :active_history_id
  # attr_accessor :cmd
 
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

    def manipulate_and_update(params, request)
      valve = self
      cmd = params['cmd']
      active_sprinkle_id = params['active_sprinkle_id']
      if cmd == ON # start valve sequence

        # change sprinkle state to ACTIVE
        sprinkle = Sprinkle.find(active_sprinkle_id)
        sprinkle.state = ACTIVE
        self.active_sprinkle_id = sprinkle.id

        # create a new history
        self.active_history_id = History.start(self).id

        # turn on the valve
        command(ON)
      else # stop valve sequence

        # change sprinkle state to IDLE
        sprinkle = Sprinkle.find(self.active_sprinkle_id)
        sprinkle.state = IDLE

        # complete the history
        history = History.find(self.active_history_id)
        history.stop

        # turn off the valve
        command(OFF)
      end
      self.save
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

