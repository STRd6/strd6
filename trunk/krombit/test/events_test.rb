require File.dirname(__FILE__) + '/test_helper.rb'

class Emitter 
  include Observable
  def initialize()
    super
  end
end

class Receiver
  include Observer
  
  attr_reader :received
  
  def initialize
    @received = nil
  end
  
  def notify(evt, *args)
    args.each{|arg| puts arg}
    
    @received = args
  end
end

class ShiftyReceiver < Receiver
  def notify(evt, *args)
    args.each{|arg| arg[:val] += 1}
    
    @received = args[0][:val]
  end
end



class EventListenerTest < Test::Unit::TestCase
  def test_new
    emitter = Emitter.new
    receiver = Receiver.new
    
    # Add a listener
    emitter.add_listener(receiver)
    
    # Greet our new listener
    emitter.notify_listeners('Greet', "Hello!")
    # The receiver should receive the message
    assert_equal ["Hello!"], receiver.received
    
    # Remove the listener
    emitter.remove_listener(receiver)
    
    # Send another message
    emitter.notify_listeners('Salud', "Goodbye!")
    # The listener did not get the 'Goodbye!' message
    assert_equal ["Hello!"], receiver.received
  end
  
  def test_shifty
    emitter = Emitter.new
    first = ShiftyReceiver.new
    second = ShiftyReceiver.new
    
    # Add listeners
    emitter.add_listener(first)
    emitter.add_listener(second)
    
    # Greet our new listener
    emitter.notify_listeners('NUMBER', {:val => 0})
    # The receiver should receive the message
    assert_equal 1, first.received
    assert_equal 2, second.received
    
    # Remove the listener
    emitter.remove_listener(first)
    
    # Send another message
    emitter.notify_listeners('NUMBER', {:val => 0})
    # The listener did not get the 'Goodbye!' message
    assert_equal 1, second.received
  end
  
end
