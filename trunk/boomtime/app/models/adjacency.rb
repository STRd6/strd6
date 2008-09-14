class Adjacency < ActiveRecord::Base
  belongs_to :area
  belongs_to :adjacent_area, :class_name => 'Area'
  
  validates_presence_of :area, :adjacent_area
end
