module GameHelper
  def render_displayable(displayable)
    render :partial => 'game/displayable_content', :locals => {:displayable => displayable}
  end
  
  def render_inventory_slot(num, item=nil)
    render :partial => 'components/inventory_slot', :locals => {:num => num, :item => item}
  end
end
