#/app/hyperloop/components/navbar.rb

class Navbar < Hyperloop::Component
  render(NAV) do
    NAV(class: 'navbar navbar-default') do
      DIV(class: 'container-fluid') do
        PorterStatus {}
        WaterStatus {}
        ValveButtons {}
      end
    end
  end

  # system host:port methods

  def system_host
    Porter.first.host_with_port
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
    WaterManager.singleton.update(state: WaterManager.singleton.state)
  end

  def system_button_state
    state_class = Hash.new
    state_class['Standby'] = 'btn-info'
    state_class['Active'] = 'btn-warning'
    state_class = {'Active': "btn-warning", 'Standby': 'btn-info'}
    state_class[system_state]
  end

  # valve methods
  
  def valve_button(valve)
    BUTTON(class: "btn #{command_toggled(valve)} navbar-btn") do
      valve.name
    end #.on(:click) {valve_command_toggled(valve)}
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

end
