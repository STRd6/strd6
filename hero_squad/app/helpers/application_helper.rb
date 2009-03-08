# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def draw_attribute(name, value)
    render :partial => "character_instances/attribute", :locals => {
      :name => name,
      :value => value,
    }
  end
  
  def update_for(page, object)
    underscored_class = object.class.to_s.underscore
    page.replace "#{underscored_class}_#{object.id}", 
      :object => object,
      :partial => "#{underscored_class.pluralize}/#{underscored_class}"
  end
end
