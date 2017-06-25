# require 'chronic'
#
# Valve definitions
#

# Common CAT 6 power: orange-brown
# Common cord power: black

# use this method to answer a time_input string based on current time + a delay in minutes
def seed_time(delay)
  (Time.now + delay*60).strftime("%a %I:%M %P")
end

# create the top-level WaterManager.singleton
WaterManager.create(state: 'Standby')
#
# rails g scaffold Valve name:string pin:integer --force
atrium = Valve.create(name: 'Atrium', gpio_pin: 7, bb_pin: 27, cpu2bb_color: 'red',         relay_module: 2, relay_index: 1, cmd: 0, base_time: Time.now)
back   = Valve.create(name: 'Back',   gpio_pin:22, bb_pin: 22, cpu2bb_color: 'cream',       relay_module: 1, relay_index: 4, cmd: 0, base_time: Time.now)
deck   = Valve.create(name: 'Deck',   gpio_pin:12, bb_pin: 12, cpu2bb_color: 'brown',       relay_module: 1, relay_index: 1, cmd: 0, base_time: Time.now)
front  = Valve.create(name: 'Front',  gpio_pin:16, bb_pin: 18, cpu2bb_color: 'white-brown', relay_module: 1, relay_index: 3, cmd: 0, base_time: Time.now)
tomato = Valve.create(name: 'Tomato', gpio_pin:18, bb_pin: 16, cpu2bb_color: 'orange',      relay_module: 1, relay_index: 2, cmd: 0, base_time: Time.now)

# production sprinkle set; keep updated as watering needs evolve.
hour = 7
%w{ Sun Mon Tue Wed Thu Fri Sat }.each do |day|
  %w{ am pm }.each do |meridian|
    Sprinkle.create( time_input: "#{day} #{hour}:00 #{meridian}", duration:  3, valve_id: atrium.id) #unless meridian == 'pm'
    Sprinkle.create( time_input: "#{day} #{hour}:05 #{meridian}", duration:  3, valve_id: back.id)
    Sprinkle.create( time_input: "#{day} #{hour}:10 #{meridian}", duration:  3, valve_id: deck.id) #unless meridian == 'pm'
    Sprinkle.create( time_input: "#{day} #{hour}:15 #{meridian}", duration:  3, valve_id: front.id) #unless meridian == 'pm'
    Sprinkle.create( time_input: "#{day} #{hour}:20 #{meridian}", duration:  5, valve_id: tomato.id)
  end
end

# testing sprinkle set; quick test of all 5 valves in 10 minutes
ix = 2
# Sprinkle.create( time_input: seed_time(ix) , duration: 1, valve_id: 1 )

# 2.times.each do
#   Valve.all.each do |valve|
#     Sprinkle.create( time_input: seed_time(ix) , duration: 1, valve_id: valve.id )
#     ix += 2
#   end
# end

# minimal system test, fire atrium for one minute after 5 minute delay
#Sprinkle.create( time_input: seed_time(5), duration: 1, valve_id: atrium.id)

