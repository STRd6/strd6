module Messenger
  protected
  # Returns the juggernaut channels for this view
  def channels
    @messenger_channels
  end
  
  def add_channel(channel)
    (@messenger_channels ||= []) << channel
  end
  
  def add_channel_for(object)
    add_channel channel_for(object) unless object.nil?
  end
  
  def channel_for(object)
    "#{object.class.name.underscore}_#{object.id}"
  end
  
  def send_to_channels(channels, &block)
    render({:juggernaut => {:type => :send_to_channels, :channels => Array(channels)}}, {}, &block)
  end
  
  def send_to_channels_for(objects, &block)
    send_to_channels Array(objects).map {|o| channel_for o}, &block
  end
end
