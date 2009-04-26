class Creation::ImagesController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  new_action.wants.html do
    render :layout => "draw"
  end

  create.before do
    @image.account = current_account
  end

  create.flash nil

  create.wants.js do
    render :update do |page|
      link = link_to "Image #{@image.id}", creation_image_path(@image.id)
      new_item_link = link_to "Create new item", new_creation_item_base_path(:image_id => @image.id)
      page.replace_html :notice, "Uploaded as #{link}<br />#{new_item_link}"
    end
  end

  show.wants.js do
    render :update do |page|
      data = @image.json_data
      page.call("canvas.loadJSON", data)
    end
  end

  def tag
    load_collection
  end

  protected
  def collection
    finder = Image
    
    if params[:tag]
      finder = finder.tagged_with(params[:tag], :on => :tags)
    end

    finder.all
  end
end
