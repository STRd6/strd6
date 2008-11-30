desc "Task for CruiseControl.rb"
task :cruise => ["db:migrate:reset"] do
  Rake::Task['test'].invoke
end