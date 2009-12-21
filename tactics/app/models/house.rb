class House < ActiveRecord::Base
  belongs_to :treeworld
  belongs_to :owner, :class_name => "Player"

  validates_presence_of :treeworld
  validates_presence_of :owner
end
