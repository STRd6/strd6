class Character < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  serialize :stats
  
  validates_length_of :name, :within => 4..32, :too_long => "pick a shorter name", :too_short => "pick a longer name"
  
  before_create :roll_stats

  def roll_stats
    str = 3 + rand(5)
    dex = 3 + rand(5)
    pow = 3 + rand(5)
    
    self.stats = {:str => str, :dex => dex, :pow => pow}
  end
  
  def stat_keys
    [:str, :dex, :pow]
  end
end
