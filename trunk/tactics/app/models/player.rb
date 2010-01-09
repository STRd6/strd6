class Player < ActiveRecord::Base
  include Treeworldly

  has_many :commands

  before_validation_on_create :initialize_path

  serialize :path

  def display_name
    name || "Anonymous #{id}"
  end

  def active_command
    commands.last(:conditions => {:state => "active"})
  end

  def step
    if (location = path.shift)
      if(move_to(*location))
        save!
        return true
      else
        update_attribute(:path, [])
      end
    elsif active_command
      update_attribute(:path, find_path_to(active_command.x, active_command.y))
    end

    return false
  end

  def move_to(x, y)
    delta_x = x - self.x
    delta_y = y - self.y

    # Make sure that the location is within range
    return unless (delta_x.abs + delta_y.abs) == 1

    if delta_x == -1
      return if wall_at(x, y, true)
    elsif delta_x == 1
      return if wall_at(x + 1, y, true)
    elsif delta_y == -1
      return if wall_at(x, y, false)
    elsif delta_y == 1
      return if wall_at(x, y + 1, false)
    end

    self.x = x
    self.y = y
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
      TreeworldNode.new(self.x, self.y, treeworld),
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
