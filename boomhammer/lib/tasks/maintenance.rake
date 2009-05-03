namespace :maintenance do
  # 0 0 * * * cd /u/apps/boomhammer/current && /usr/bin/rake RAILS_ENV=production maintenance:daily
  desc "Daily update to characters"
  task :daily => [:environment, 'maintenance:backup:db', 'maintenance:backup:images'] do
    # Update characters
    Character.all.each do |character|
      character.daily_update
    end
  end

  # 30 * * * * cd /u/apps/boomhammer/current && /usr/bin/rake RAILS_ENV=production maintenance:image_patrol
  desc "Remove offensive images"
  task :image_patrol => [:environment] do
    Image.remove_offensive
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

    desc "Download today's date image backup from server to 'images.tar'"
    task :pull_images do
      date_string = Date.today.to_date.to_s
      `scp -P 2112 daniel@67.207.139.110:/u/apps/boomhammer/shared/backups/images_#{date_string}.tar images.tar`
    end

    desc "Download today's date sqlite backup from production server to development"
    task :pull_db do
      date_string = Date.today.to_date.to_s
      `scp -P 2112 daniel@67.207.139.110:/u/apps/boomhammer/shared/backups/production_#{date_string}.sqlite3 db/development.sqlite3`
    end
  end
end
