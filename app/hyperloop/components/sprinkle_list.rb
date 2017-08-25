require 'models/sprinkle'
require 'models/valve'
require 'time'

class SprinkleList < Hyperloop::Component

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
    # @sprinkles = Sprinkle.all.each do |sprinkle|
    #   sprinkle.update(state: 'Idle')
    # end
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
    H4 { "Sprinkles"}
    TABLE(class: 'table-bordered') do
      THEAD do
        TR do
          TH { " State "}
          TH { " Next Start Time " }          
          TH { " Time input " }
          TH { " Duration" }
          TH { " Valve " }
        end
      end
      TBODY do
        sort(Sprinkle.all).each do |sprinkle|
          TR do
            TD { sprinkle.state }

            TD { formatted_time(sprinkle.next_start_time) }
          
            TD { sprinkle.time_input }    
          
            TD { sprinkle.duration.to_s }
          
            TD { sprinkle.valve.name }
          end
        end
        mark_next
      end
    end  
  end

  def sort(sprinkles)
    sprinkles.sort_by! {|s| s.next_start_time}
    sprinkles
  end

  def mark_next
    # Set the status of the first sprinkle in the list to 'Next'
    s = Sprinkle.all
    s[0].state = 'Next'
    s[0].save
  end

  def formatted_time(t)
    t = t.nil? ?  Time.now : t
    # t.strftime("%a %d %b %l:%M %P")
    t.strftime("%a %b %d %l:%M %P")
  end

end