class Ability < ActiveRecord::Base
  def activated?
    cost
  end
  
  def passive?
    !cost
  end
end
