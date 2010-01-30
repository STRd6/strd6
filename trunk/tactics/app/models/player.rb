class Player < ActiveRecord::Base
  include Treeworldly
  include Locatable

  has_many :commands

  has_many :items, :as => :container

  before_validation_on_create :initialize_path

  serialize :path

  delegate :build_wall_at, :to => :treeworld

  def display_name
    name || "Anonymous #{id}"
  end

  def active_command
    commands.last(:conditions => {:state => "active"})
  end

  # Returns a single changed game object to update or nil.
  def step
    if (location = path.shift)
      if(move_to(*location))
        save!
        return self
      else
        update_attribute(:path, [])
      end
    elsif active_command
      if active_command.location == self.location
        return active_command.perform
      else
        #TODO: Path can't be found
        update_attribute(:path, find_path_to(active_command.x, active_command.y))
      end
    end

    nil
  end

  def move_to(x, y)
    #TODO: Torroidal direction and magnitude
    delta_x = x - self.x
    delta_y = y - self.y

    # Make sure that the location is within range
    #TODO: Torroidal distance check
    # return unless (delta_x.abs + delta_y.abs) == 1

    if delta_x == -1
      return if wall_at(self.x, self.y, true)
    elsif delta_x == 1
      return if wall_at(self.x + 1, self.y, true)
    elsif delta_y == -1
      return if wall_at(self.x, self.y, false)
    elsif delta_y == 1
      return if wall_at(self.x, self.y + 1, false)
    end

    self.x = x
    self.y = y
  end

  def node
    TreeworldNode.new(self.x, self.y, treeworld)
  end

  def heuristic_torroidal(a, b)
    x = (a.x - b.x).abs
    y = (a.y - b.y).abs

    if width - x < x
      x = width - x
    end

    if height - y < y
      y = height - y
    end

    return x + y
  end

  def find_path_to(x, y)
    self.path = GraphHelper.a_star(
      node,
      TreeworldNode.new(x, y, treeworld),
      method(:heuristic_torroidal)
    ).map do |node|
      [node.x, node.y]
    end
  end

  def move_towards(x, y)
    delta_x = x - self.x
    delta_y = y - self.y

    if delta_x != 0 && delta_y != 0
      r = rand(delta_x.abs + delta_y.abs)
      if r < delta_x.abs
        self.x += (delta_x <=> 0)
      else
        self.y += (delta_y <=> 0)
      end
    elsif delta_x != 0
      self.x += (delta_x <=> 0)
    elsif delta_y != 0
      self.y += (delta_y <=> 0)
    end

    save!
  end

  def initialize_path
    self.path ||= []
  end
end
