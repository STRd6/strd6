class ImagesController < ResourceController::Base
  actions :all, :except => :destroy

  layout 'draw'

  create.wants.js do
    render :update do |page|
      link = link_to "Image #{@object.id}", @object
      page.replace_html :notice, "Uploaded as #{link}"
    end
  end

  #skip_before_filter :verify_authenticity_token
end
