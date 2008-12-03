# This module takes care of keeping a hash of stat modifications

module StatModifier
  def self.included(recipient)
    recipient.extend(ModelClassMethods)
    recipient.class_eval do
      serialize :stat_mods
      before_validation_on_create :ensure_stat_mods
      
      include ModelInstanceMethods
    end
  end
  
  module ModelClassMethods
    
  end
  
  module ModelInstanceMethods
    # Returns the modification for the given stat, 0 (unmodified) is the default
    def mod_for(stat)
      stat_mods[stat] || 0
    end
    
    protected
    def ensure_stat_mods
      self.stat_mods ||= {}
    end
  end
end
