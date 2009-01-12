# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def draw_attribute(name, value)
    render :partial => "character_instances/attribute", :locals => {
      :name => name,
      :value => value,
    }
  end
end
