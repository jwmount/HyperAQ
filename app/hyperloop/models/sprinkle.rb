require 'time'
require 'json'

# crontab format
# [Minute] [hour] [Day_of_the_Month] [Month_of_the_Year] [Day_of_the_Week] 
#  parsed.min   parsed.hour  Time.now.mday       Time.now.mon       compute from(Time.now.wday and parsed value)
#                                                                   Time.now.wday <= parsed.wday  
#                                                                     (parsed.wday - Time.now.wday)* 24 * 60 * 60

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
TIME_INPUT_STRFTIME = "%a %d %b %l:%M %P"

STATES = %w{ NEXT ACTIVE IDLE }

OPEN = 1
CLOSE = 0

LOGFILE = "log/sprinkle.log"

def log(msg)
  f = File.open(LOGFILE, 'a')
  f.write msg
  f.close
end


class Sprinkle < ActiveRecord::Base
  belongs_to :valve
  validates :time_input, :duration, :valve_id, presence: true
  
  #
  # business logic methods
  #

  # answer a Time object representing the next start_time
  def start_time
    # merge the schedule weekday, hour and minute with today's year, month, weekday to form the next start_time
    t = Time.now
    s = Time.parse(time_input)
    log "Time.parse --> #{time_as_string(s)}\n"

    answer = Time.new(t.year, t.mon, t.mday, s.hour, s.min, 0)
    log "raw answer --> #{time_as_string(answer)}\n"

    # adjust weekday so the answer weekday aligns with time_input weekday
    answer += DAY_OF_WEEK_MAP[s.wday][answer.wday] * SECONDS_PER_DAY
    answer_as_string = answer.strftime(TIME_INPUT_STRFTIME)
    log "sprinkle.start_time --> #{time_as_string(answer)}\n"

    answer    
  end

  #answer a string formatted to crontab time standards.  Answer start_time if action is 1 (OPEN),
  #answer stop_time if action is 0 (CLOSE)
  def to_crontab(action)
    log "Sprinkle.to_crontab(#{action})\n"
    if action == OPEN
      t = start_time
      # log "start_time --> #{t.strftime("%a %d %b %l:%M %P")}\n"    
    else
      t = start_time + duration*60
      # log "stop_time --> #{t.strftime("%a %d %b %l:%M %P")}\n"
    end
    t.strftime(CRONTAB_STRFTIME)
  end

  private

    def time_as_string(t)
      t.strftime(TIME_INPUT_STRFTIME)
    end
 
end
