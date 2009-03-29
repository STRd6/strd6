# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def item_link(item)
    link_to item, {:controller => 'item_bases', :action => 'show', :id => item.item_base_id}, :class => 'link_item'
  end
end
