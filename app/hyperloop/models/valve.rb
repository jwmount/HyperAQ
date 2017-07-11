require 'models/application_record'
require 'time'

class Valve < ApplicationRecord
  has_many :sprinkles
  # has_many :histories
  # has_many :scheduled_sprinkle_events
  # has_many :histories, foreign_key: "history_id", class_name: "History" # I think that is right...
  has_many :histories #, inverse_of: :valve
  #has_many :scheduled_sprinkle_events

  if RUBY_ENGINE != 'opal'

    # shorthand for "WaterManager.singleton.logger"
    def logger
      WaterManager.singleton.logger
    end

    def manipulate_and_update(params, request)
      logger.info "Valve #{self.name}, cmd: #{self.cmd}"
      # logger.info "Valve #{self}"
      case params['cmd']
      when '1' # start valve sequence
        # logger.info "cmd --> #{params['cmd']}, start a valve sequence"
        start
        
      when '0' # stop valve sequence
        # logger.info "cmd --> #{params['cmd']}, stop valve sequence"
        stop
      end
    end

    def start
      update(cmd: 1, base_time: Time.now)
      # logger.info "valve #{name}(#{id}), cmd #{cmd}"
      # allocate a History object, recording the start time and saving the History record.
      # History.start(self)
      # open the valve to start the sequence
      command(self.cmd)
    end

    # close the valve and also close the History object tracking it
    def stop
      update(cmd: 0)
      # logger.info "valve #{name}, cmd #{cmd}, current_history.id "
      # current_history.stop
      # turn off the valve
      command(self.cmd)
    end

    # send command(s) to Raspberry PI GPIO pins (using WiringPI global shell command, gpio)
    def command(val)
      mode = "gpio -g mode #{gpio_pin} out"
      write = "gpio -g write #{gpio_pin} #{val}"
      # logger.info "Valve:command --> #{mode}"
      system(mode)
      # logger.info "Valve:command --> #{write}"
      system(write)
    end

    # answer a set of parameters needed by rest_client.rb
    def to_crontab(action)
      "%2d %2d" % [id, action] 
    end

    # def to_gpio_pin(action)
    #   "#{gpio_pin} #{action}"
    # end

  end # RUBY_ENGINE
end

