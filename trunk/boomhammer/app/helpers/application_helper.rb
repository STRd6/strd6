# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def item_link(item)
    link_to image_for(item), {:controller => 'creation/item_bases', :action => 'show', :id => item.item_base_id}, :class => 'link_item'
  end

  def equip_link(item)
    if item.equipped?
      link_to "Unequip #{item}", {
        :controller => 'actions',
        :action => 'unequip_item',
        :item_id => item.id,
      }
    elsif Item::EquipSlots::EQUIPPED.include? item.allowed_slot
      link_to "Equip #{item}:#{item.allowed_slot_name}", {
        :controller => 'actions',
        :action => 'equip_item',
        :item_id => item.id,
        :item_slot => item.allowed_slot
      }
    else
      nil
    end
  end

  def area_link_action_link(area_link)
    link_to image_for(area_link.linked_area), {
      :controller => 'actions',
      :action => 'take_area_link',
      :area_link_id => area_link.id
    }
  end

  def opportunity_action_link(opportunity)
    link_to image_for(opportunity), {
      :controller => 'actions',
      :action => 'take_opportunity',
      :opportunity_id => opportunity.id
    }
  end

  def recipe_action_link(recipe)
    link_to "Make #{recipe}?", {
      :controller => 'actions',
      :action => 'make_recipe',
      :recipe_id => recipe.id
    }
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

  def requirements_list(object)
    if object.requisites.size > 0
      object.requisites.map do |requisite|
        image_for requisite
      end
    end
  end
end
