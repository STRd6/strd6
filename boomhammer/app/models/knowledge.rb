class Knowledge < ActiveRecord::Base
  belongs_to :character
  belongs_to :object, :polymorphic => true
end
