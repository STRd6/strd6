require 'ruby-prof'

namespace :game do
  task :run => :environment do
    step_size = 0.10
    world = Treeworld.first
    count = 0


    #RubyProf.start

    while true
      start_time = Time.now
      
      world.reload
      world.step

      total_time = Time.now - start_time

      if (count % 10) == 0
        puts "STEP: #{count}"
        puts "TIME: #{total_time}"
      end

      sleep(step_size - [step_size, total_time].min)

      break if count == 100

      count += 1
    end

    #result = RubyProf.stop
    #printer = RubyProf::FlatPrinter.new(result)
    #printer.print(STDOUT, 0)
  end
end