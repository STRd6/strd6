class Creation::ShopsController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  update.before do
    @shop.top = params[:y].to_i - SMALL_IMAGE_HEIGHT/2;
    @shop.left = params[:x].to_i - SMALL_IMAGE_WIDTH/2;
  end

  update.wants.html do
    redirect_to creation_area_path(@shop.area)
  end
end
