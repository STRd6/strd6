class Creation::ImagesController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  new_action.wants.html do
    render :layout => "draw"
  end

  create.flash nil

  create.wants.js do
    render :update do |page|
      link = link_to "Image #{@object.id}", creation_image_path(@image.id)
      page.replace_html :notice, "Uploaded as #{link}"
    end
  end

  #skip_before_filter :verify_authenticity_token
end
