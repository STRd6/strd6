module Renderino
  def render_to_area(area, &block)
    render({:juggernaut => {:type => :send_to_channels, :channels => [area.channel]}}, {}, &block)
  end
end