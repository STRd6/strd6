namespace :maintenance do
  desc "Daily update to characters"
  # 0 0 * * * cd /u/apps/boomhammer/current && /usr/bin/rake RAILS_ENV=production maintenance:daily
  task :daily do
    Character.all.each do |character|
      character.daily_update
    end
  end
end
