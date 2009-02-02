class Character < ActiveRecord::Base  
  serialize :base_stats
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  belongs_to :default_ability_1, :class_name => 'Ability'
  belongs_to :default_ability_2, :class_name => 'Ability'
  belongs_to :default_ability_3, :class_name => 'Ability'
end
