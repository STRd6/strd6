class Treeworld < ActiveRecord::Base
  has_many :trees

  has_many :players

  def self.generate(width=32, height=32, trees=(width*height)/2)
    world = new(:width => width, :height => height)

    trees.times do
      world.trees.build(:x => rand(width), :y => rand(height), :treeworld => world)
    end

    world.save!

    world
  end

  def world_data
    to_json(:include => [:trees, :players])
  end

  def step
    trees.each(&:step)

    players.each(&:step)
  end

  def channel
    :"treeworld_#{id}"
  end
end