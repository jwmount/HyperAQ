#/app/hyperloop/components/navbar.rb

class Navbar < Hyperloop::Component
  render(NAV) do
    NAV(class: 'navbar navbar-inverse') do
      DIV(class: 'container-fluid') do
        DIV(class: 'navbar-header') do
          A(class: 'navbar-brand') do
            system_host
          end
        end
        UL(class: 'nav navbar-nav') do
          system_button
        end
        UL(class: 'nav navbar-nav navbar-right') do
          Valve.all.each do |valve|
            LI { valve_button(valve) }
          end
        end
      end
    end
  end

  # system button methods

  def system_button
    BUTTON(class: "btn #{system_button_state} navbar-btn") do 
      system_state
    end.on(:click) {state_button_toggled}
  end

  def system_state
    WaterManager.singleton.state
  end

  def state_button_toggled
    state_toggle = Hash.new
    state_toggle['Standby'] = 'Active'
    state_toggle['Active'] = 'Standby'
    WaterManager.singleton.state = state_toggle[WaterManager.singleton.state]
    WaterManager.singleton.save
    #
    # invoke ServerOp here to effect the system state change just requested
    # 
    SystemStateChange
  end

  def system_button_state
    state_class = Hash.new
    state_class['Standby'] = 'btn-info'
    state_class['Active'] = 'btn-warning'
    state_class = {'Active': "btn-warning", 'Standby': 'btn-info'}
    state_class[system_state]
  end

  # system host:port methods

  def system_host
    Document.ready? do
      fake_http_patch
    end
    "http://#{WaterManager.singleton.http_host}"
  end

  # valve methods
  
  def valve_button(valve)
    BUTTON(class: "btn #{valve_state(valve)} navbar-btn") do
      valve.name
    end.on(:click) {valve_command_toggled(valve)}
  end

  def valve_command_toggled(valve)
    valve_cmd_toggle = { '0': '1', '1': '0'}
    valve.cmd = valve_cmd_toggle[valve.cmd.to_s].to_i
    valve.save
  end

  def valve_state(valve)
    valve_class = {'0': "btn-primary", '1': 'btn-success'}
    valve_class[valve.cmd.to_s]
  end

  # http methods to support ServerOp FetchPortNumber{}
  def fake_http_patch
    # refer to https://github.com/opal/opal-jquery in order to build a patch request inside state_button_toggled

    WaterManager.singleton.save
    Porter.first.update(port_number: '2999', host_name: 'foober')
  end

  def update_model_record(model)
     route = "/#{model.class.name.pluralize}"
     payload = model.to_json
     HTTP.patch(route, payload) do |req| #needs id
       #set breakpoint at porters index and inspect the request hash, looking for 
       #the actual request string received.
     end
  end
end
