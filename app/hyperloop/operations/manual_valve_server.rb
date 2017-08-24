class ManualValveServer < Hyperloop::ServerOp
  param :acting_user, nils: true
  param :valve_id #, type: Number
  dispatch_to { Hyperloop::Application }

  ON =  1
  OFF = 0

  step do 
    manual_valve_update(params.valve_id)
  end

  LOGFILE = "log/manual_valve.log"

  def log(msg)
    f = File.open(LOGFILE, 'a')
    f.write msg
    f.close
  end

  def manual_valve_update(id)
    # fetch the valve instance
    valve = Valve.find(id)
    # change state
    valve.update(cmd: (valve.cmd == ON ? OFF : ON))
    # refresh in-memory valve object
    valve = Valve.find(id)
    log "Valve #{valve.name}.cmd --> #{valve.cmd}\n"
    
    # start/stop a History record for this valve.
    if valve.cmd == ON 
      history = History.start(valve)
      valve.active_history_id = history.id
      log "created a new history @ #{history.start_time_display}\n"
    else
      history = History.find(valve.active_history_id)
      history.stop
      log "update and save History(#{history.id}) @ #{history.stop_time_display}\n"
      valve.active_history_id = 0
    end

    # Finally fire the actual valve GPIO bit
    valve.save!
    valve.command(valve.cmd)
  end

end 

