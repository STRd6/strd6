# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def item_link(item)
    link_to image_for(item), {:controller => 'creation/item_bases', :action => 'show', :id => item.item_base_id}, :class => 'link_item'
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

  def account_badges(account)
    Badge.for_account_id(account.id)
  end

  def login_area
    render :partial => 'components/login'
  end
  
  def intrinsic_checkbox_array(object, method, existing)
    render :partial => 'creation/intrinsic_checkbox_array', :locals => {
      :object => object,
      :method => method,
      :existing => existing,
    }
  end
end
