# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def item_link(item)
    link_to item, {:controller => 'item_bases', :action => 'show', :id => item.item_base_id}, :class => 'link_item'
  end
  
  def area_link_action_link(area_link)
    link_to area_link.linked_area, :controller => 'characters', :action => 'take_area_link', :id => area_link.id
  end

  def opportunity_action_link(opportunity)
    link_to opportunity, {:controller => 'characters', :action => 'take_opportunity', :id => opportunity.id}
  end

  def recipe_action_link(recipe)
    link_to "Make #{recipe}?", {:controller => 'characters', :action => 'make_recipe', :id => recipe.id}
  end
end
