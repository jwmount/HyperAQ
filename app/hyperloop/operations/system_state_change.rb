# app/hyperloop/operations/system_state_change.rb
# 
# Inputs: nothing
#
# * This is invoked as the result of one of the valve buttons being pushed and entering the 'on' state (cmd == 1)
#
class SystemStateChange < Hyperloop::ServerOp

  if RUBY_ENGINE != 'opal'
    step { system('touch log/application.log') }
    step { system('echo "SystemStateChange.run" >> log/application.log') }
    # w = WaterManager.singleton
    # if w.state == 'Active'
    #   w.arm
    # else
    #   w.disarm
    # end
  end

end