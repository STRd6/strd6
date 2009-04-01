module Imageable
  def self.included(model)
    model.class_eval do
      belongs_to :image
      
      delegate :file_name, :to => :image, :prefix => :image, :allow_nil => true
    end
  end
end
