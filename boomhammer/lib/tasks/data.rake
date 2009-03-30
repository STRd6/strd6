namespace :data do
  desc "Populate sample app data"
  task :populate => :environment do
    DataMeister.populate
  end
end