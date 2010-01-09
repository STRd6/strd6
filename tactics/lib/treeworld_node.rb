# To change this template, choose Tools | Templates
# and open the template in the editor.

class TreeworldNode
  attr_reader :x, :y, :treeworld

  def initialize(x, y, treeworld)
    @x = x % treeworld.width
    @y = y % treeworld.height
    @treeworld = treeworld
  end

  def neighbors
    connected = []

    connected.push TreeworldNode.new(x - 1, y, treeworld) unless treeworld.wall_at(x, y, true)
    connected.push TreeworldNode.new(x, y - 1, treeworld) unless treeworld.wall_at(x, y, false)
    connected.push TreeworldNode.new(x + 1, y, treeworld) unless treeworld.wall_at(x + 1, y, true)
    connected.push TreeworldNode.new(x, y + 1, treeworld) unless treeworld.wall_at(x, y + 1, false)

    return connected.compact
  end

  def to_s
    "[#{x}, #{y}]"
  end

  def ==(other)
    return x == other.x && y == other.y && treeworld == other.treeworld
  end

  def eql?(other)
    self == other
  end

  def <=>(other)
    if self.y == other.y
      self.x <=> other.x
    else
      self.y <=> other.y
    end
  end
end
