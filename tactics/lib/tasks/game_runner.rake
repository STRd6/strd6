namespace :game do
  task :run => :environment do
    step_size = 0.10
    world = Treeworld.last
    count = 0

    while true
      start_time = Time.now
      begin
        Treeworld.transaction do
          world.reload
          world.step
        end
      rescue
        puts $!
      end

      total_time = Time.now - start_time

      if (count % 10) == 0
        puts "STEP: #{count}"
        puts "TIME: #{total_time}"
      end

      sleep(step_size - [step_size, total_time].min)

      break if count == 1000

      count += 1
    end
  end
end