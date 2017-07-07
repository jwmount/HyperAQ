require 'models/application_record'
class WaterManager < ApplicationRecord

  #
  # on/off code for GPIO.
  #
  OPEN = 1
  CLOSE = 0

  def self.singleton
    WaterManager.first
  end

  if RUBY_ENGINE != 'opal'
    require 'logger'

    # SystemStateChange{}

    def logger
      if !@logger
        @logger = Logger.new("#{Rails.root}/log/application.log")
        @logger.datetime_format=("%a %b %-d %l:%M:%S%P ")
      end
      @logger
    end
    
    # handle the side effect(s) of a database update prior to actually doing the update
    def manipulate_and_update(params, request)
      # pick off http_host from request.env hash, add to params for WaterManager update, only once.
      if host_with_port.to_s.empty?
        params["http_host"] = "#{request.host}:#{request.port}"
        update(params)
        true
      end
    end

    def arm
      logger.info "WaterManager state --> #{state}"
      logger.info "Building crontab"
      # remove_crontab
      install_crontab
    end

    def disarm
      logger.info "WaterManager state --> #{state}"
      logger.info "Removing crontab"
      remove_crontab
      Valve.all.each do |v|
        # close only those valves that are open.
        if v.cmd == 1
          v.stop
        end
      end
    end

    # minute (0-59), hour (0-23, 0 = midnight), day (1-31), month (1-12), weekday (0-6, 0 = Sunday), command( valve_id, on/off,host:port)
    def install_crontab
      # create a working crontab file
      f = File.open(CRONTAB, 'w')
      f.write "MAIL='keburgett@gmail.com'\n"
      # for each sprinkle, write a crontab entry for OPEN and CLOSE times.
      Sprinkle.all.each do |s|
        [OPEN, CLOSE].each do |action|
          crontab_line =  "#{s.to_crontab(action)} sh #{valve_actuator_path} #{s.valve.to_crontab(action)} #{host_with_port}\n" 
          f.write crontab_line
          # logger.info crontab_line
        end
      end
      f.close
      system("crontab #{CRONTAB}")
    end

    def remove_crontab
      system("crontab -r")
      system("touch lib/tasks/crontab")
      system("rm lib/tasks/crontab")
    end

    def valve_log_file_path
      File.realdirpath('log/history.log')
    end

    def valve_actuator_path
      File.realdirpath('lib/tasks/valve_actuator.sh')
    end

    # this should return something like "aquarius:2017"
    def host_with_port
      WaterManager.singleton.http_host
    end
  end # if RUBY_ENGINE..
end #class...
