class GameEntry < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  
  validates_presence_of :game, :player
end
