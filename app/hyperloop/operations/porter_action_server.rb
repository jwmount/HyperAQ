class PorterActionServer < Hyperloop::ServerOp
  param :acting_user, nils: true
  dispatch_to { Hyperloop::Application }

  PID_FOLDER = 'tmp/pids'

  step do 
    host_with_port 
  end

  def host_with_port
    Porter.first.host_name = `hostname`.strip
    Porter.first.port_number = extract_port_from_pidfile
    Porter.first.save!
    system('touch log/porter.log')
    system("echo 'PorterActionServer is alive!!' >> log/porter.log")
  end

  # development-2017.pid
  def extract_port_from_pidfile
    files = Dir["#{PID_FOLDER}*"]
    if files.length == 0
      return '3000'
    else
      # files.each do |file|
      #   array = file.scan /\w/

      # end
      return '2017'
    end
  end

end 

