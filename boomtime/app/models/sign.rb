class Sign < ActiveRecord::Base
  include Displayable
  include Costs
  
  validates_length_of :text, :in => 1..255
  
  belongs_to :area
  belongs_to :creator, :class_name => 'Character'
  
  def overlay_text
    text
  end
  
  def costs
    {:wood => 1}
  end
end
