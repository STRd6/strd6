class Tree < ActiveRecord::Base
  include Treeworldly

  def step
    if rand(1000) == 0
      self.age += 1
      save!
      return true
    end

    return false
  end
end
