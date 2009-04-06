namespace :maintenance do
  # 0 0 * * * cd /u/apps/boomhammer/current && /usr/bin/rake RAILS_ENV=production maintenance:daily
  desc "Daily update to characters"
  task :daily => :environment do
    date_string = Date.today.to_date.to_s
    shared = "/u/apps/boomhammer/shared"
    # Update characters
    Character.all.each do |character|
      character.daily_update
    end

    # Backup DB
    `cp #{shared}/db/production.sqlite3 #{shared}/backups/production_#{date_string}.sqlite3`

    # Backup images
    `tar -cf #{shared}/backups/images_#{date_string}.tar public/production`
  end
end
