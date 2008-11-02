# Run with god -c /path/to/file.god

RAILS_ROOT = "/u/apps/boomtime/current"

%w{8000 8001}.each do |port|
  God.watch do |w|
    w.name = "boomtime-mongrel-#{port}"
    w.group = 'mongrels'
    w.interval = 30.seconds # default      
    w.start = "mongrel_rails start -c #{RAILS_ROOT} -p #{port} -e production \
      -P #{RAILS_ROOT}/log/mongrel.#{port}.pid  -d"
    w.stop = "mongrel_rails stop -P #{RAILS_ROOT}/log/mongrel.#{port}.pid"
    w.restart = "mongrel_rails restart -P #{RAILS_ROOT}/log/mongrel.#{port}.pid"
    w.start_grace = 10.seconds
    w.restart_grace = 10.seconds
    w.pid_file = File.join(RAILS_ROOT, "log/mongrel.#{port}.pid")
    
    #w.behavior(:clean_pid_file)

    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.interval = 5.seconds
        c.running = false
      end
    end
    
    w.restart_if do |restart|
      restart.condition(:memory_usage) do |c|
        c.above = 150.megabytes
        c.times = [3, 5] # 3 out of 5 intervals
      end
    
      restart.condition(:cpu_usage) do |c|
        c.above = 50.percent
        c.times = 5
      end
    end
    
    # lifecycle
    w.lifecycle do |on|
      on.condition(:flapping) do |c|
        c.to_state = [:start, :restart]
        c.times = 5
        c.within = 5.minute
        c.transition = :unmonitored
        c.retry_in = 10.minutes
        c.retry_times = 5
        c.retry_within = 2.hours
      end
    end
  end
end

#God.watch do |w|
#  juggernaut_config_file = File.join(RAILS_ROOT, 'config', 'juggernaut.yml')
#  juggernaut_log_file = File.join(RAILS_ROOT, 'log', 'juggernaut.log')
#
#  w.name = "boomtime-juggernaut"
#  w.pid_file = File.join(RAILS_ROOT, "log/juggernaut.pid")
#  w.group = 'juggernaut'
#  w.interval = 30.seconds # default      
#  w.start = "juggernaut -d -c #{juggernaut_config_file} --pid #{w.pid_file} --log #{juggernaut_log_file}"
#  #TODO: Determine pid correctly
#  w.stop = "kill #{pid}"
#  w.restart = "#{w.stop}; sleep 3; #{w.start}"
#  w.start_grace = 15.seconds
#  w.restart_grace = 15.seconds
#
#  #w.behavior(:clean_pid_file)
#
#  w.start_if do |start|
#    start.condition(:process_running) do |c|
#      c.interval = 5.seconds
#      c.running = false
#    end
#  end
#
#  w.restart_if do |restart|
#    restart.condition(:memory_usage) do |c|
#      c.above = 150.megabytes
#      c.times = [3, 5] # 3 out of 5 intervals
#    end
#
#    restart.condition(:cpu_usage) do |c|
#      c.above = 50.percent
#      c.times = 5
#    end
#  end
#
#  # lifecycle
#  w.lifecycle do |on|
#    on.condition(:flapping) do |c|
#      c.to_state = [:start, :restart]
#      c.times = 5
#      c.within = 5.minute
#      c.transition = :unmonitored
#      c.retry_in = 10.minutes
#      c.retry_times = 5
#      c.retry_within = 2.hours
#    end
#  end
#end

