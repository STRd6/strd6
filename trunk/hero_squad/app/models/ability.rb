class Ability < ActiveRecord::Base
  include StatModifier
  
  def activated?
    cost
  end
  
  def passive?
    !cost
  end
end
