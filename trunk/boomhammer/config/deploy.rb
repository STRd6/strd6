require 'mongrel_cluster/recipes'

set :application, "boomhammer"
set :repository,  "http://strd6.googlecode.com/svn/trunk/#{application}"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"

ssh_options[:port] = 2112

role :app, "67.207.139.110"
role :web, "67.207.139.110"
role :db,  "67.207.139.110", :primary => true

namespace :juggernaut do
  desc "Stop the juggernaut push server"
  task :stop , :roles => :app do
    run "cd #{current_path} && rake juggernaut:stop RAILS_ENV=production"
  end

  desc "Start the juggernaut push server"
  task :start, :roles => :app do
    run "cd #{current_path} && rake juggernaut:start RAILS_ENV=production"
  end

  desc "Restart the juggernaut push server"
  task :restart, :roles => :app do
    run "cd #{current_path} && rake juggernaut:restart RAILS_ENV=production"
  end
end