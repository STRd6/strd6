class Annotation < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  
  attr_accessor :public

  before_save :check_public
  
  attr_accessible :top, :left, :text, :url
  
  private
  def check_public
    if public && public != 'false'
      self.owner_id = 0
    end
  end
end
