class Ability < ActiveRecord::Base
  include StatModifier
  
  before_validation_on_create :ensure_attribute_expressions, :set_default_target_type
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def passive?
    !activated?
  end
  
  ACTION_ATTRIBUTES = [:energy_cost, :life_loss, :damage, :energy_damage, 
    :heal, :energy_gain, :duration, :actions_required, :area, :range].freeze
  
  ACTION_ATTRIBUTES.each do |attr|
    case attr
    when :energy_cost, :life_loss, :damage, :energy_damage, :heal, :energy_gain, :duration
      define_method attr do |character|
        if attribute_expressions[attr]
          character.instance_eval attribute_expressions[attr], "Ability: id = #{id}"
        else
          0
        end
      end
    when :actions_required, :area, :range
      define_method attr do |character|
        if attribute_expressions[attr]
          character.instance_eval attribute_expressions[attr], "Ability: id = #{id}"
        else
          1
        end
      end
    end
  end
  
  private
  def ensure_attribute_expressions
    self.attribute_expressions ||= {}
  end
  
  def set_default_target_type
    self.target_type ||= Target::ANY
  end
end
