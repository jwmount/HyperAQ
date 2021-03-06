require 'time'
# Valve definitions
#

# Common CAT 6 power: orange-brown
# Common cord power: black

# create the top-level WaterManager.singleton
WaterManager.create(state: 'Standby')
#
# create the Porter singleton
#
Porter.create(host_name: 'localhost', port_number: 3000)
#
# rails g scaffold Valve name:string pin:integer --force
atrium = Valve.create(name: 'Atrium', gpio_pin: 7, cmd:0, bb_pin: 27, cpu2bb_color: 'red',         relay_module: 2, relay_index: 1)
back   = Valve.create(name: 'Back',   gpio_pin:22, cmd:0, bb_pin: 22, cpu2bb_color: 'cream',       relay_module: 1, relay_index: 4)
deck   = Valve.create(name: 'Deck',   gpio_pin:12, cmd:0, bb_pin: 12, cpu2bb_color: 'brown',       relay_module: 1, relay_index: 1)
front  = Valve.create(name: 'Front',  gpio_pin:16, cmd:0, bb_pin: 18, cpu2bb_color: 'white-brown', relay_module: 1, relay_index: 3)
tomato = Valve.create(name: 'Tomato', gpio_pin:18, cmd:0, bb_pin: 16, cpu2bb_color: 'orange',      relay_module: 1, relay_index: 2)

# production sprinkle set; keep updated as watering needs evolve.
# hour = 7
# %w{ Sun Mon Tue Wed Thu Fri Sat }.each do |day|
#   [0, 12].each do |meridian|
#     Sprinkle.create( time_input: "#{day} #{hour+meridian}:00" , duration:  3, valve_id: atrium.id, state: 'Idle') #unless meridian == 12
#     Sprinkle.create( time_input: "#{day} #{hour+meridian}:05" , duration:  3, valve_id: back.id, state: 'Idle')
#     Sprinkle.create( time_input: "#{day} #{hour+meridian}:10" , duration:  3, valve_id: deck.id, state: 'Idle') unless meridian == 12
#     Sprinkle.create( time_input: "#{day} #{hour+meridian}:15" , duration:  3, valve_id: front.id, state: 'Idle') #unless meridian == 12
#     Sprinkle.create( time_input: "#{day} #{hour+meridian}:20" , duration:  5, valve_id: tomato.id, state: 'Idle')
#   end
# end

# use this method to answer a time_input string based on current time + a delay in minutes
def seed_time(delay)
  (Time.now + delay*60).strftime("%a %I:%M %P")
end

# testing sprinkle set; quick test of all 5 valves in 10 minutes
ix = 2
# Sprinkle.create( time_input: seed_time(ix) , duration: 1, valve_id: 1 )

2.times.each do
  Valve.all.each do |valve|
    Sprinkle.create( time_input: seed_time(ix) , duration: 1, valve_id: valve.id, state: 'Idle' )
    ix += 2
  end
end

# minimal system test, fire atrium for one minute after 5 minute delay
#Sprinkle.create( time_input: seed_time(5), duration: 1, valve_id: atrium.id)

# Test Histories
# ix = Time.now
# 2.times.each do
#   Valve.all.each do |valve|
#     History.create(valve_id: valve.id, start_time: ix, stop_time: ix + 5*60)
#     ix = ix + 6*60
#   end
# end

