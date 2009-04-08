module Creation::CreationHelper
  def chunked_index(collection)
    render :partial => 'creation/index', :locals => {:collection => collection}
  end
end
