bundle install
rails g model History start_time:datetime stop_time:datetime valve_id:integer start_display:string stop_display:string --force
rails g model Sprinkle next_start_time:datetime base_start_time:datetime state:string time_input:string duration:integer valve_id:integer state:string --force
rails g scaffold Valve name:string gpio_pin:integer active_sprinkle_id:integer active_history_id:integer cpu2bb_color:string bb_pin:integer \
  bb2relay_color:string relay_module:integer relay_index:integer relay2valve_color:string cmd:integer base_time:datetime --force
# rails g model WaterManager state:string --force
rails g scaffold Porter host_name:string port_number:string --force

sh dev-bounce-db.sh
rails g hyperloop:install
rails g hyper:component App


