# This module takes care of keeping a hash of stat modifications

module StatModifier
  def self.included(recipient)
    recipient.extend(ModelClassMethods)
    recipient.class_eval do
      before_validation_on_create :ensure_stat_mods
      include ModelInstanceMethods
    end
  end
  
  module ModelClassMethods
    
  end
  
  module ModelInstanceMethods
    protected
    def ensure_stat_mods
      self.stat_mods ||= {}
    end
  end
end
