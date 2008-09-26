module WindowPimp
protected
  #Inclusion hook for window stuff in da' viewz
  def self.included(base)
    base.send :helper_method, :window_style if base.respond_to? :helper_method
  end
  
  def window_style(window)
    return "" unless current_user && w = WindowPosition.find_by_user_id_and_window(current_user.id, window) 
    
    return "top: #{w.top}px; left: #{w.left}px;"
  end
end