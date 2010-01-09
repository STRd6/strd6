class Treeworld < ActiveRecord::Base
  has_many :trees
  has_many :players
  has_many :walls
  has_many :houses

  def self.generate(width=32, height=32, trees=(width*height)/2)
    world = new(:width => width, :height => height)

    trees.times do
      world.trees.build(:x => rand(width), :y => rand(height), :treeworld => world, :planted_at => -rand(4200))
    end

    world.save!

    world
  end

  def world_data
    to_json(
      :include => {
        :trees => {},
        :players => {},
        :walls => {:methods => :orientation},
        :houses => {}
      }
    )
  end

  def wall_at(x, y, vertical)
    return walls.first(:conditions => {
      :vertical => vertical,
      :x => x,
      :y => y
    })
  end

  def node_at(x, y)
    return TreeworldNode.new(x, y)
  end

  def step
    increment :age

    changed_players = players.select(&:step)

    update_channel(changed_players)
  end

  def channel
    :"treeworld_#{id}"
  end

  def update_channel(changed_objects)
    Juggernaut.send_to_channel("updateWorld(#{changed_objects.to_json});", channel)
  end
end
