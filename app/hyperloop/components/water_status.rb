
  class WaterStatus < Hyperloop::Component

    ACTIVE =  'Active'
    STANDBY = 'Standby'

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
      # @water = WaterManager.first
    end

    before_update do
      # called whenever a component will be re-rerendered
    end

    before_unmount do
      # cleanup any thing (i.e. timers) before component is destroyed
    end

    def render
      UL(class: 'nav navbar-nav')  do
        LI do
          BUTTON(class: "btn #{system_button_state} navbar-btn") do 
            system_state
          end.on(:click) {state_button_toggled}
        end
      end
    end

    def system_state
      WaterManager.first.state
    end

    def state_button_toggled
      # WaterManager.first.update(state: (system_state == ACTIVE ? STANDBY : ACTIVE))
      # add call to ServerOp which changes the server state in accordance with the state variable
      WaterManagerServer.run(wm_id: WaterManager.first.id)
    end

    def system_button_state
      system_state == ACTIVE ? 'btn-warning' : 'btn-info'
    end

  end

