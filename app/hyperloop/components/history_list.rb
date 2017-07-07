require 'models/history'
require 'models/valve'
require 'time'

class HistoryList < Hyperloop::Component
  
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
            # TD { valve_name(history.valve_id) }
            # TD { "valve.name"}
 
          end
        end
      end
    end
  end

  def formatted_time(t)
    t.strftime("%a %d %b %l:%M %P")
  end

  def valve_name(history)
    # problem with History (Histories) belongs_to, has_many relationship to Valve, may be inflection problem.
    # history.valve.name does not work.
    v = Valve.find(history.valve_id)
    v.id.to_s
  end
end

