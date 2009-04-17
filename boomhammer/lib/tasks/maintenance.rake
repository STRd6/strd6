namespace :maintenance do
  # 0 0 * * * cd /u/apps/boomhammer/current && /usr/bin/rake RAILS_ENV=production maintenance:daily
  desc "Daily update to characters"
  task :daily => [:environment, 'maintenance:backup:db', 'maintenance:backup:images'] do
    # Update characters
    Character.all.each do |character|
      character.daily_update
    end
  end

  namespace :backup do
    desc "Backup the production database"
    task :db do
      date_string = Date.today.to_date.to_s
      shared = "/u/apps/boomhammer/shared"

      # Backup DB
      `cp #{shared}/db/production.sqlite3 #{shared}/backups/production_#{date_string}.sqlite3`
    end

    desc "Backup all the images"
    task :images do
      date_string = Date.today.to_date.to_s
      shared = "/u/apps/boomhammer/shared"

      # Backup images
      `tar -cf #{shared}/backups/images_#{date_string}.tar #{shared}/production/`
    end
  end
end
