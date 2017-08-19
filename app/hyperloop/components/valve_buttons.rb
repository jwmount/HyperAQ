class ValveButtons < Hyperloop::Component

  before_mount do
    @valves = Valve.all
  end

  def render
    UL(class: 'nav navbar-nav navbar-right') do
      @valves.each do |valve|
        ValveButton(valve: valve)
      end
    end
  end
end

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
    # puts "state(valve): #{state(valve)}"
    ManualValveServer.run(valve_id: valve.id)
  end

  def state(valve)
    valve.cmd == 0 ? "btn-primary" : 'btn-success'
  end

end