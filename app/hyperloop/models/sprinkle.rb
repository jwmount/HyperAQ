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
TIME_INPUT_STRFTIME = ""

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
  
  # parse the time input string, returning a Time object
  def schedule_time
    ti = Time.parse(time_input)
    
    t = Time.now
    answer = Time.new(t.year, t.mon, t.mday, ti.hour, ti.minute)
    answer += (ti.wday - t.wday) * SECONDS_PER_DAY 
    self.next_start_time = answer
    self.save
    answer
  end

  # answer a Time object representing the next start_time
  def start_time
    # merge the schedule weekday, hour and minute with today's year, month, weekday and second to form the next start_time
    t = Time.now
    s = schedule_time

    schedule_time_as_string = s.strftime("%a %d %b %l:%M %P")
    # log "sprinkle.schedule_time --> #{schedule_time_as_string}\n"

    answer = Time.new(t.year, t.mon, t.mday, s.hour, s.min)
    # adjust weekday so the answer weekday aligns with schedule_time weekday
    while s.wday < t.wday
      answer += DAY_OF_WEEK_MAP[s.wday][answer.wday] * SECONDS_PER_DAY
    end
    while t.wday < s.wday
    end
    # if the computed time is earlier than the current time, then bump it by a week
    if answer < t
      # log "answer < t\n"
      answer += SECONDS_PER_WEEK 
    end

    answer_as_string = answer.strftime("%a %d %b %l:%M %P")
    # log "sprinkle.start_time --> #{answer_as_string}\n"

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
 
end
