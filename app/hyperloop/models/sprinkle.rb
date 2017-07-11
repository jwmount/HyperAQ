require 'models/application_record'
class Sprinkle < ApplicationRecord
  belongs_to :valve

  if RUBY_ENGINE != 'opal'
    def logger
      WaterManager.singleton.logger
    end

    # parse the time input string, returning a Time object
    def schedule_time
      @next_start_time ||= Chronic.parse(time_input)
    end

    # answer a Time object representing the next start_time
    def start_time
      # merge the schedule hour and minute with today's year, month, day and second to form start_time
      t = Time.now
      answer = Time.new(t.year, t.mon, t.mday, schedule_time.hour, schedule_time.min)
      # adjust weekday so the answer weekday aligns with schedule_time weekday
      answer += DAY_OF_WEEK_MAP[schedule_time.wday][answer.wday] * AppConstants::SECONDS_PER_DAY
      # if the computed time is earlier than the current time, then bump it by a week
      if answer < t
        answer += AppConstants::SECONDS_PER_WEEK 
      end
      answer
    end

    #answer a string formatted to crontab time standards.  Answer start_time if action is 1 (OPEN),
    #answer stop_time if action is 0 (CLOSE)
    def to_crontab(action)
      # logger.info "to_crontab(#{action})"
      if action == AppConstants::OPEN
        t = start_time
        # logger.info "start_time --> #{t.to_i}"    
      else
        t = start_time + duration*60
        # logger.info "stop_time --> #{t.to_i}"
      end
      t.strftime(AppConstants::CRONTAB_STRFTIME)
    end

  end # RUBY_ENGINE

end
