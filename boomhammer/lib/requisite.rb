# Handles models that have requisite abilities to access
# Requires that including model have a `requisites` column in DB
module Requisite
  def self.included(model)
    model.class_eval do
      serialize :requisites
      validates_presence_of :requisites
      before_validation_on_create :set_default_requisites, :sanitize_requisites
    end
  end

  # Returns true if the given attributes meet the requsite for this model
  def requisite_met?(attributes)
    return true if requisites.include? 'any'

    requisites.each do |requisite|
      return true if attributes[requisite]
    end

    return false
  end

  protected
  # The DB default doesn't seem to work correctly, so we'll put this here
  # This sets the default requisites to [:any] as in nothing special required
  # it keeps whatever was set previously though, so chillax.
  def set_default_requisites
    self.requisites ||= ['any']
  end

  def sanitize_requisites
    self.requisites = Intrinsic.sanitize(self.requisites)
    self.requisites << 'any' if self.requisites.size == 0
  end
end
