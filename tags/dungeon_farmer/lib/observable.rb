module Observable
  def add_listener(method, listener)
    to_notify = @listeners[method]
    if to_notify
      to_notify << listener
    else  
      @listeners[method] = [listener]
    end
  end
  
  def remove_listener(method, listener)
    to_notify = @listeners[method]
    if to_notify
      to_notify.delete(listener)
    end
  end
  
  def notify(*args)
    puts "notifying: [#{args.join(', ')}]"
    method = args.slice!(0)
    to_notify = @listeners[method]
    if to_notify
      to_notify.each do |listener|
        listener.send(method, *args)
      end
    end
  end
end
