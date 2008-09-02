class Character < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  serialize :stats
  
  validates_length_of :name, :within => 4..32, :too_long => "pick a shorter name", :too_short => "pick a longer name"
  
  before_create :roll_stats

  def roll_stats
    str = 2 + rand(6)
    dex = 2 + rand(6)
    pow = 2 + rand(6)
    
    self.stats = {:str => str, :dex => dex, :pow => pow}
  end
end
