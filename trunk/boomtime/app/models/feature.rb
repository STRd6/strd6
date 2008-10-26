class Feature < ActiveRecord::Base
  include Displayable
  include Propertied
  include Costs
  
  belongs_to :area
  belongs_to :creator, :class_name => 'Character'
  
  def proteus
    {
      :tree => {:image => 'plants/tree1'},
      :bush => {:image => 'plants/bush3'}
    }
  end
  
  def costs
    {:seeds => 1}
  end
end
