# This module contains the subsystem for initializing, altering, retrieving
# and storing 'properties' on game objects. These properties are way cool for
# letting users add custom stuff.
#
module Propertied
  def self.included(recipient)
    recipient.extend(ModelClassMethods)
    recipient.class_eval do
      serialize :properties
      before_create :initialize_properties
      include ModelInstanceMethods
    end
  end

  module ModelClassMethods
  end # class methods

  module ModelInstanceMethods
    def proteus
      {}
    end
  
    def initialize_properties
      self.properties ||= {}
    end

    # Currently a very fake style of prototype inheritance, just copy
    # properties from the prototype over to the instance.
    def prototype=(prototype)
      self.properties ||= {}

      if prototype
        @prototype = prototype.to_sym
        self.properties.merge! proteus[@prototype] if proteus[@prototype]
      end
    end

    def prototype
      @prototype
    end

    def web_image
      if properties[:image]
        file = properties[:image]
      elsif display_datum.image
        file = display_datum.image
      else
        file = "default"
      end

      return "#{self.class.name.underscore.pluralize}/#{file}"
    end
    
    def name
      if properties[:name]
        return properties[:name]
      else
        return super
      end
    end
  end # instance methods
  
end
