class Feature < ActiveRecord::Base
  include Displayable
  
  belongs_to :area
  belongs_to :creator, :class_name => 'Character'
  
  serialize :properties
  
  before_create :initialize_properties
  
  def initialize_properties
    self.properties = {}
  end
end
