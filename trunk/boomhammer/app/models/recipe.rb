class Recipe < ActiveRecord::Base
  validates_presence_of :name

  has_many :recipe_components, :dependent => :destroy
  has_many :recipe_outcomes, :dependent => :destroy
end
