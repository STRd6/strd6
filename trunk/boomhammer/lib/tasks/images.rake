namespace :images do
  desc "Populate image db entries for images that are missing entries"
  task :populate => :environment do
    file_names = Dir["#{Rails.root}/public/production/images/*"]

    file_names.each do |file_name|
      basename = File.basename(file_name)
      image = Image.find_by_file_name basename

      if image.nil?
        Image.create(:file_name => basename)
      end
    end
  end

  desc "Destroy image db entries for missing images"
  task :cull => :environment do
    Image.find_each do |image|
      image.destroy unless File.exists? "#{Rails.root}/public/production/images/#{image.file_name}"
    end
  end
end