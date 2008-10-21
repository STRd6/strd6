class Feature < ActiveRecord::Base
  include Displayable
  
  belongs_to :area
  belongs_to :creator, :class_name => 'Character'
  
  serialize :properties
  
  before_create :initialize_properties
  
  def initialize_properties
    self.properties ||= {}
  end
  
  def image
    if properties[:image]
      file = properties[:image]
    elsif display_datum.image
      file = display_datum.image
    else
      file = "default"
    end
    
    return "#{self.class.name.underscore.pluralize}/#{file}"
  end
end
