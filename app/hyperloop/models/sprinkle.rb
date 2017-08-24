require 'time'
require 'json'

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
TIME_INPUT_STRFTIME = ""

STATES = %w{ NEXT ACTIVE IDLE }

OPEN = 1
CLOSE = 0

WEEKDAYS = %w{ sun mon tue wed thu fri sat }

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
    ti = TimeInput.new(time_input)

    t = Time.now
    answer = Time.new(t.year, t.mon, t.mday, ti.hour, ti.minute)
    # log "schedule time 1 --> #{answer.strftime("%a %d %b %l:%M %P")}\n"
    answer += (t.wday - ti.weekday) * SECONDS_PER_DAY 
    # log "schedule time 2 --> #{answer.strftime("%a %d %b %l:%M %P")}\n"
    # if ti.meridian == 'pm'
    #   answer += SECONDS_PER_HOUR * 12
    # end
    # log "schedule time 3 --> #{answer.strftime("%a %d %b %l:%M %P")}\n"

    self.next_start_time = answer
    self.save
    answer
  end

  # answer a Time object representing the next start_time
  def start_time
    # merge the schedule hour and minute with today's year, month, day and second to form start_time
    t = Time.now
    s = schedule_time

    schedule_time_as_string = s.strftime("%a %d %b %l:%M %P")
    # log "sprinkle.schedule_time --> #{schedule_time_as_string}\n"

    answer = Time.new(t.year, t.mon, t.mday, s.hour, s.min)
    # adjust weekday so the answer weekday aligns with schedule_time weekday
    answer += DAY_OF_WEEK_MAP[s.wday][answer.wday] * SECONDS_PER_DAY
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

class TimeInput
  def initialize(time_input_string)
    time_input_string.downcase!
    # log "TimeInput(#{time_input_string})\n"
    array = time_input_string.split(' ')
    # log "array --> #{array}\n"
    @weekday = WEEKDAYS.find_index(array[0])
    # log "@weekday --> #{@weekday}\n"
    time = array[1].split(':')
    # log "time --> #{time}\n"
    @hour = time[0].to_i
    # log "@hour --> #{@hour}\n"
    @minute = time[1].to_i
    # log "@minute --> #{@minute}\n"
    @meridian = array[2]
    # log "@meridian --> #{@meridian}\n"
  end

  def weekday
    @weekday
  end

  def hour
    @hour
  end

  def minute
    @minute
  end

  def meridian
    @meridian
  end
end
