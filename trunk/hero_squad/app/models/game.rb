class Game < ActiveRecord::Base
  has_many :entries, :class_name => 'GameEntry'
  has_many :players, :through => :entries
end
