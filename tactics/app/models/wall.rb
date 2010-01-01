class Wall < ActiveRecord::Base
  belongs_to :treeworld

  validates_presence_of :treeworld
  validates_numericality_of :x, :greater_than_or_equal_to => 0
  validates_numericality_of :y, :greater_than_or_equal_to => 0
  validates_inclusion_of :vertical, :in => [true, false]

  def horizontal?
    !vertical?
  end

  def orientation
    vertical? ? :vertical : :horizontal
  end
end
