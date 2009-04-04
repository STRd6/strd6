namespace :data do
  desc "Populate sample app data"
  task :populate => :environment do
    DataMeister.populate
  end

  namespace :populate do
    desc "Populate intrinsics"
    task :intrinsics => :environment do
      DataMeister.populate_intrinsics
    end
  end
end