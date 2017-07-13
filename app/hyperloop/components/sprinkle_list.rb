require 'models/sprinkle'
require 'models/valve'
require 'time'

class SprinkleList < Hyperloop::Component
  render(DIV) do
    H4 { "Sprinkles" }
    TABLE(class: 'table-bordered') do
      THEAD do
        TR do
          TH { " Next Start Time " }          
          TH { " Time input " }
          TH { " Duration" }
          TH { " Valve " }
        end
      end
      TBODY do
        Sprinkle.all.each do |sprinkle| 
          TR do
            TD { formatted_time(sprinkle.next_start_time)}
            # TD { "today" }

            TD { sprinkle.time_input }    
            # TD { "tue 8:35 am" }      

            TD { sprinkle.duration.to_s }
            # TD { "duration" }

            TD { sprinkle.valve.name }
            # TD { "sammy" }
          end
        end
      end
    end  
  end

  def formatted_time(t)
    t = t.nil? ?  Time.now : t
    t.strftime("%a %d %b %l:%M %P")
  end
end