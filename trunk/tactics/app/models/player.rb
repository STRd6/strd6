class Player < ActiveRecord::Base
  include Treeworldly

  has_many :commands

  def display_name
    name || "Anonymous #{id}"
  end

  def active_command
    commands.first(:conditions => {:state => "active"})
  end

  def step
    puts("STEP")
    puts("START: #{x}, #{y}")
    if active_command
      move_towards(active_command.x, active_command.y)
    end
    puts("END: #{x}, #{y}")
  end

  def move_towards(x, y)
    delta_x = x - self.x
    delta_y = y - self.y

    if delta_x != 0 && delta_y != 0
      r = rand(delta_x.abs + delta_y.abs)
      if r < delta_x
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
end
