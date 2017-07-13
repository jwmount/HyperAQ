bundle install
rails g model History start_time:datetime stop_time:datetime valve_id:integer --force
rails g model Sprinkle next_start_time:datetime base_start_time:datetime state:string time_input:string duration:integer valve_id:integer --force
rails g model Valve name:string gpio_pin:integer cpu2bb_color:string bb_pin:integer bb2relay_color:string relay_module:integer \
  relay_index:integer relay2valve_color:string cmd:integer base_time:datetime --force
rails g model WaterManager state:string http_host:string --force s

rails g scaffold ScheduledSprinkleEvent sprinkle_id:integer valve_id:integer history_id:integer valve_cmd:integer 

sh dev-bounce-db.sh
rails g hyperloop:install
rails g hyper:component App
#
# Server Actuator Models, called by manual embedding of patch requests, routed to controller update method.
#
# rails g scaffold CrontabActuator state:string
rails g scaffold Porter host_name:string port_number:string
# rails g scaffold ValveActuator valve_id:integer cmd:integer

