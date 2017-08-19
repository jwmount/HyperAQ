require 'models/history'
require 'models/valve'
require 'time'

class HistoryList < Hyperloop::Component
  
  # param :my_param
  # param param_with_default: "default value"
  # param :param_with_default2, default: "default value" # alternative syntax
  # param :param_with_type, type: Hash
  # param :array_of_hashes, type: [Hash]
  # collect_other_params_as :attributes  # collects all other params into a hash

  # The following are the most common lifecycle call backs,
  # the following are the most common lifecycle call backs# delete any that you are not using.
  # call backs may also reference an instance method i.e. before_mount :my_method

  before_mount do
    # any initialization particularly of state variables goes here.
    # this will execute on server (prerendering) and client.
  end

  after_mount do
    # any client only post rendering initialization goes here.
    # i.e. start timers, HTTP requests, and low level jquery operations etc.
  end

  before_update do
    # called whenever a component will be re-rerendered
  end

  before_unmount do
    # cleanup any thing (i.e. timers) before component is destroyed
  end  
    
  render(DIV) do
    H4 { "Histories"}
    TABLE(class: 'table-bordered') do
      THEAD do
        TR do
          TH { "Start time" }
          TH { "Stop time" }
          TH { "Valve" }
        end
      end
      TBODY do
        History.all.each do |history| 
          TR do
            
            TD { formatted_time(history.start_time) }
            # TD { "start time"}

            TD { formatted_time(history.stop_time) }
            # TD { "stop time"}

            TD { history.valve_id.to_s }
            # TD { Valve.find(history.valve_id).name }
            # TD { "valve.name"}
 
          end
        end
      end
    end
  end

  def formatted_time(t)
    return ' ' if t.nil? 
    t.strftime("%a %d %b %l:%M %P")
  end

  def valve_name(valve_id)
    # problem with History (Histories) belongs_to, has_many relationship to Valve, may be inflection problem.
    # history.valve.name does not work.
    v = Valve.find(valve_id)
    v.name
  end
end
