class Sign < ActiveRecord::Base
  belongs_to :area
  belongs_to :creator, :class_name => 'Character'
end
