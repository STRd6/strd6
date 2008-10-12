class Feature < ActiveRecord::Base
  include Displayable
  
  belongs_to :area
end
