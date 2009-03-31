module Imageable
  def self.included(model)
    model.class_eval do
      has_one :image, :as => :imageable, :dependent => :destroy
      
      delegate :file_name, :to => :image, :prefix => :image, :allow_nil => true
    end
  end
end
