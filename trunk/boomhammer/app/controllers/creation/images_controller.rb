class Creation::ImagesController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  new_action.wants.html do
    render :layout => "draw"
  end

  create.flash nil

  create.wants.js do
    render :update do |page|
      link = link_to "Image #{@image.id}", creation_image_path(@image.id)
      new_item_link = link_to "Create new item", new_creation_item_base_path(:image_id => @image.id)
      page.replace_html :notice, "Uploaded as #{link}<br />#{new_item_link}"
    end
  end

  #skip_before_filter :verify_authenticity_token
end
