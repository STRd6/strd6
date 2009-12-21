class Wall < ActiveRecord::Base
  belongs_to :treeworld

  validates_presence_of :treeworld
  validate :must_be_spatially_correct

  def must_be_spatially_correct
    if x1 == x2
      if (y2 - y1).abs != 1
        errors.add_to_base("Wall location isn't contiguous")
      end
    elsif y1 == y2
      if (x2 - x1).abs != 1
        errors.add_to_base("Wall location isn't contiguous")
      end
    else
      errors.add_to_base("Wall isn't aligned on either x or y")
    end
  end

  def orientation
    if x1 == x2
      :horizontal
    else
      :vertical
    end
  end
end
