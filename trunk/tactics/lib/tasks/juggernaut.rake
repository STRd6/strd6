namespace :juggernaut do
  task :app_env do
    Rake::Task[:environment].invoke if defined?(RAILS_ROOT)
  end
  
  desc "Start a juggernaut push server using juggernaut settings"
  task :start => :app_env do
    raise RuntimeError, "juggernaut is already running." if juggernaut_running?    
  
    cmd = "juggernaut -d -c #{juggernaut_config_file} --pid #{juggernaut_pid_file} --log #{juggernaut_log_file}"
    puts cmd
    system cmd
    
    sleep(2)
    
    if juggernaut_running?
      puts "Started successfully (pid #{juggernaut_pid})."
    else
      puts "Failed to start juggernaut push server. Check logs."
    end
  end
  
  desc "Stop Juggernaut push server using Juggernaut's settings"
  task :stop => :app_env do
    raise RuntimeError, "juggernaut is not running." unless juggernaut_running?
    pid = juggernaut_pid
    system "kill #{pid}"
    puts "Stopped juggernaut push server (pid #{pid})."
  end
  
  desc "Restart juggernaut"
  task :restart => [:app_env, :stop, :start]
  
end

def juggernaut_running?
  if File.exist?(juggernaut_pid_file) 
    process_check = `ps -p #{juggernaut_pid} | wc -l`
    juggernaut_pid && process_check.to_i > 1
  end
end

def juggernaut_pid
  `cat #{juggernaut_pid_file}`.to_i
end

def juggernaut_pid_file
  File.join(RAILS_ROOT, 'log', 'juggernaut.pid')
end

def juggernaut_log_file
  File.join(RAILS_ROOT, 'log', 'juggernaut.log')
end

def juggernaut_config_file
  File.join(RAILS_ROOT, 'config', 'juggernaut.yml')
end
