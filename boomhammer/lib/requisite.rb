# Handles models that have requisite abilities to access
# Requires that including model have a `requisites` column in DB
module Requisite
  def self.inculded(model)
    model.class_eval do
      serialize :requisites
      validates_presence_of :requisites
    end
  end

  # Returns true if the given attributes meet the requsite for this model
  def requisite_met?(attributes)
    return true if requisites.include? :any

    requisites.each do |requisite|
      return true if attributes[requisite]
    end

    return false
  end
end
