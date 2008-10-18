class Feature < ActiveRecord::Base
  include Displayable
  
  belongs_to :area
  belongs_to :creator, :class_name => 'Character'
end
