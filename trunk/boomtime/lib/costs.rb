# This module contains the subsystem for applying costs to the creator of 
# model instances.
# 
# Model must supply creator, costs methods.
#
module Costs
  def self.included(recipient)
    recipient.extend(ModelClassMethods)
    recipient.class_eval do
      after_validation :subtract_resources
      include ModelInstanceMethods
    end
  end

  module ModelClassMethods
  end # class methods

  module ModelInstanceMethods
    # This method is intended to be called after validation to 
    # make sure that the creator can pay the costs to create 
    # this instance.
    def subtract_resources
      if creator
        if creator.pay costs
          return true
        else
          errors.add_to_base "Unable to pay #{costs}"
          return false
        end
      else
        errors.add_to_base "No creator."
        return false
      end
    end
  end # instance methods
end
