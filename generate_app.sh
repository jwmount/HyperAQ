rails g model History start_time:datetime stop_time:datetime valve_id:integer --force
rails g model Sprinkle next_start_time:datetime base_start_time:datetime time_input:string duration:integer valve_id:integer --force
rails g model Valve name:string gpio_pin:integer cpu2bb_color:string bb_pin:integer bb2relay_color:string relay_module:integer \
  relay_index:integer relay2valve_color:string cmd:integer base_time:datetime
rails g model WaterManager state:string http_host:string --force
rails g model SprinkleEvent sprinkle_id:integer valve_id:integer history_id:integer

rails g hyperloop:install
