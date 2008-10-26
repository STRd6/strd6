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
    def initialize_properties
      self.properties ||= {}
    end

    def prototype=(prototype)
      self.properties ||= {}

      if prototype
        @prototype = prototype.to_sym
        self.properties.merge! Proteus[@prototype] if Proteus[@prototype]
      end
    end

    def prototype
      @prototype
    end

    def image
      if properties[:image]
        file = properties[:image]
      elsif display_datum.image
        file = display_datum.image
      else
        file = "default"
      end

      return "#{self.class.name.underscore.pluralize}/#{file}"
    end
  end # instance methods
  
end
