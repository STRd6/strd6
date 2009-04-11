# Handles models that have requisite abilities to access
# Adds a has_many :requisites and a `requisites_met?(attributes)` method
module Requisite
  def self.included(model)
    model.class_eval do
      has_many :requisites, :as => :owner, :dependent => :destroy, :class_name => "Intrinsic"

      before_save :save_new_requisites
    end
  end

  # Returns true if the given attributes meet the requsites for this model
  def requisites_met?(attributes)
    attributes_intrinsic_base_ids = attributes.map(&:intrinsic_base_id)
    intrinsic_base_ids.each do |id|
      return false unless attributes_intrinsic_base_ids.include? id
    end

    return true
  end
  
  def intrinsic_base_ids
    requisites.map(&:intrinsic_base_id)
  end

  def intrinsic_base_ids=(ids)
    @intrinsic_base_ids = ids
  end

  def can_be_discovered_by?(character)
    return true if requisites_met? character.net_abilities
    return false if invisible?
    return true
  end

  def invisible?
    requisites.any? {|requisite| requisite.intrinsic_base.name == "see invisible"}
  end

  protected
  def save_new_requisites
    if @intrinsic_base_ids
      existing_ids, new_ids = @intrinsic_base_ids.partition {|id| intrinsic_base_ids.include? id }

      # Delete the old ones
      requisites.each do |requisite|
        requisite.destroy unless existing_ids.include? requisite.intrinsic_base_id
      end

      # Add the new ones
      new_ids.each do |id|
        requisites.build :intrinsic_base_id => id
      end
    end
  end
end
