namespace :maintenance do
  # 0 0 * * * cd /u/apps/boomhammer/current && /usr/bin/rake RAILS_ENV=production maintenance:daily
  desc "Daily update to characters"
  task :daily => :environment do
    Character.all.each do |character|
      character.daily_update
    end
  end
end
