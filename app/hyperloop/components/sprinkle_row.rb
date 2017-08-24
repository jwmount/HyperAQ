require 'models/sprinkle'
require 'models/valve'
require 'time'

class SprinkleRow < Hyperloop::Component
  param :sprinkle

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

  render do
    TR do
      TD { params.sprinkle.state }

      TD { formatted_time(params.sprinkle.next_start_time) }
    
      TD { params.sprinkle.time_input }    
    
      TD { params.sprinkle.duration.to_s }
    
      TD { params.sprinkle.valve.name }
    end
  end

  def formatted_time(t)
    t = t.nil? ?  Time.now : t
    # t.strftime("%a %d %b %l:%M %P")
    t.strftime("%a %b %d %l:%M %P")
  end

end