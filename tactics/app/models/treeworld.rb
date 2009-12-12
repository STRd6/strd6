class Treeworld < ActiveRecord::Base
  has_many :trees

  def self.generate(width=32, height=32, trees=(width*height)/2)
    world = new(:width => width, :height => height)

    trees.times do
      world.trees.build(:x => rand(width), :y => rand(height))
    end

    world.save!

    world
  end
end
