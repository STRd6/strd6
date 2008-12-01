class Ability < ActiveRecord::Base
  include StatModifier
  before_validation_on_create :ensure_attribute_expressions
  
  def passive?
    !activated?
  end
  
  ACTION_ATTRIBUTES = [:energy_cost, :hit_point_cost, :damage, :energy_damage, 
    :heal, :energy_gain, :duration, :actions_required, :area, :range].freeze
  
  ACTION_ATTRIBUTES.each do |attr|
    case attr
    when :energy_cost, :hit_point_cost, :damage, :energy_damage, :heal, :energy_gain, :duration
      define_method attr do
        if attribute_expressions[attr]
          eval attribute_expressions[attr], binding, "Ability: id = #{id}"
        else
          0
        end
      end
    when :actions_required, :area, :range
      define_method attr do
        if attribute_expressions[attr]
          eval attribute_expressions[attr], binding, "Ability: id = #{id}"
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
end
