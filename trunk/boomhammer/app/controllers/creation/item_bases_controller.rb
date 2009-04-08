class Creation::ItemBasesController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  new_action.before do
    @item_base.granted_abilities = []
    @item_base.image_id = params[:image_id]
  end
  
  show.before do
    @title = @item_base.name
  end

  protected
  def collection
    ItemBase.all find_opts
  end

  def find_opts
    {
      :include => :image,
      :order => "name ASC",
    }
  end
end
