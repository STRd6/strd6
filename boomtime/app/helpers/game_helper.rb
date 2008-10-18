module GameHelper
  def render_displayable(displayable)
    render :partial => 'game/displayable_content', :locals => {:displayable => displayable}
  end
end
