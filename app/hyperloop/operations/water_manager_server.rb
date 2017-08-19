class WaterManagerServer < Hyperloop::ServerOp
  param :acting_user, nils: true
  param :wm_id #, type: Number
  dispatch_to { Hyperloop::Application }

  ACTIVE =  'Active'
  STANDBY = 'Standby'

  OPEN = 1
  CLOSE = 0

  CRONTAB = 'lib/assets/crontab'

  step do 
    water_manager_update(params.wm_id)
  end

  LOGFILE = "log/water_manager.log"

  def log(msg)
    f = File.open(LOGFILE, 'a')
    f.write msg
    f.close
  end

  def water_manager_update(id)
    wm = WaterManager.find(id)
    # change state
    wm.update(state: (wm.state == ACTIVE ? STANDBY : ACTIVE))
    wm = WaterManager.find(id)
    log "wm.state --> #{wm.state}\n"
    
    if wm.state == ACTIVE
      log "wm.arm\n"
      arm
    else
      log "wm.disarm\n"
      disarm
    end
  end

  def arm
    install_crontab
  end

  def disarm
    log "Removing crontab"
    remove_crontab
    Valve.all.each do |v|
      # close only those valves that are open.
      if v.cmd == 1
        v.stop
      end
    end
  end

  # minute (0-59), hour (0-23, 0 = midnight), day (1-31), month (1-12), weekday (0-6, 0 = Sunday), command(valve_id, on/off, host:port, sprinkle)
  # 03 19 * * 2 sh /home/kenb/development/Aquarius/lib/tasks/scheduled_sprinkle_actuator.sh  v_id cmd hp s_id

  # where

  # VALVE_ID=$1,    v_id
  # CMD=$2,         cmd
  # HTTP_HOST=$3    localhost:nnnn
  # SPRINKLE_ID=$4  s_id
  def install_crontab
    # create a working crontab file
    log "Building crontab\n"
    f = File.open(CRONTAB, 'w')
    f.write "MAIL='keburgett@gmail.com'\n"
    # for each sprinkle, write a crontab entry for OPEN and CLOSE times.
    p = Porter.first
    Sprinkle.all.each do |s|
      [OPEN, CLOSE].each do |action|
        crontab_line =  "#{s.to_crontab(action)} sh #{valve_actuator_path} #{s.valve.to_crontab(action)} #{p.localhost_with_port} #{s.id}\n" 
        f.write crontab_line
      end
    end
    f.close
    # system("crontab #{CRONTAB}")
  end

  def remove_crontab
    system("crontab -r")
    system("touch lib/tasks/crontab")
    system("rm lib/tasks/crontab")
  end

  def valve_actuator_path
    File.realdirpath('lib/tasks/valve_actuator.sh')
  end

end 

