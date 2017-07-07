# /app/hyperloop/operations/manual_valve_activate.rb
# 
# Inputs: a valve_id
#
# * This is invoked as the result of one of the valve buttons being pushed and entering the 'off' state (cmd == 0)

class ManualValveDeactivate < Hyperloop::ServerOp
  # v = Valve.find(valve_id)
  # v.stop
end