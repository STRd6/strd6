class WindowPosition < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :window, :top, :left, :user
end
