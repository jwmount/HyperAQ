
#   current day of week            event day of week
#   SU  MO  TU  WE  TH  FR  SA
DAY_OF_WEEK_MAP =[
  [ 0,  6,  5,  4,  3,  2,  1 ], # SU
  [ 1,  0,  6,  5,  4,  3,  2 ], # MO
  [ 2,  1,  0,  6,  5,  4,  3 ], # TU
  [ 3,  2,  1,  0,  6,  5,  4 ], # WE
  [ 4,  3,  2,  1,  0,  6,  5 ], # TH
  [ 5,  4,  3,  2,  1,  0,  6 ], # FR
  [ 6,  5,  4,  3,  2,  1,  0 ]  # SA
]
# useful time constants
SECONDS_PER_HOUR = 60*60
SECONDS_PER_DAY = 24*SECONDS_PER_HOUR
SECONDS_PER_WEEK = SECONDS_PER_DAY * 7

CRONTAB_STRFTIME = "%02M %02H * * %w"

STATES = %w{ NEXT ACTIVE IDLE }

OPEN = 1
CLOSE = 0

class Sprinkle < ActiveRecord::Base
  # before_save    { 
  #                   self.base_start_time = Chronic.parse(self.time_input) 
  #                   self.next_start_time = self.start_time
  #                }
  belongs_to :valve
  validates :time_input, :duration, :valve_id, presence: true

  #
  # business logic methods
  #
  if RUBY_ENGINE != 'opal'
    require 'time'
    require 'chronic'

    LOGFILE = "log/water_manager.log"

    def log(msg)
      f = File.open(LOGFILE, 'a')
      f.write msg
      f.close
    end

    # parse the time input string, returning a Time object
    def schedule_time
      @next_start_time ||= Chronic.parse(time_input)
    end

    # answer a Time object representing the next start_time
    def start_time
      # merge the schedule hour and minute with today's year, month, day and second to form start_time
      t = Time.now
      s = schedule_time
      answer = Time.new(t.year, t.mon, t.mday, s.hour, s.min)
      # adjust weekday so the answer weekday aligns with schedule_time weekday
      answer += DAY_OF_WEEK_MAP[s.wday][answer.wday] * SECONDS_PER_DAY
      # if the computed time is earlier than the current time, then bump it by a week
      if answer < t
        answer += SECONDS_PER_WEEK 
      end
      answer
    end

    #answer a string formatted to crontab time standards.  Answer start_time if action is 1 (OPEN),
    #answer stop_time if action is 0 (CLOSE)
    def to_crontab(action)
      log "to_crontab(#{action})"
      if action == OPEN
        t = start_time
        # logger.info "start_time --> #{t.to_i}"    
      else
        t = start_time + duration*60
        # logger.info "stop_time --> #{t.to_i}"
      end
      t.strftime(CRONTAB_STRFTIME)
    end
  end # RUBY_ENGINE
end
