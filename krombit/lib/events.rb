module Observer
  def notify(*args)
    
  end  
end

module Observable
  def initialize(*args)
    obs_init
  end
  
  def obs_init
    @listeners = []
  end
  
  def add_listener(listener)
    @listeners.push(listener)
  end
  
  def remove_listener(listener)
    @listeners.delete(listener)
  end 
  
  def notify_listeners(*args)
    @listeners.each do |listener|
      listener.notify(*args)
    end
  end
  
end
