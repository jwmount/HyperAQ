class ValveButton < Hyperloop::Component
  param :valve

  def render
    LI do
      BUTTON(class: "btn #{state(params.valve)} navbar-btn") do
        params.valve.name
      end.on(:click) {command(params.valve)}
    end
  end

  def command(valve)
    # signal the ServeOp to toggle the valve, and create a History
    ManualValveServer.run(valve_id: valve.id)
    Layout.render
  end

  def state(valve)
    valve.cmd == 0 ? "btn-primary" : 'btn-success'
  end

end