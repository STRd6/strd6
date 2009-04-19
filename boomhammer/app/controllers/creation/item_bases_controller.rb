class Creation::ItemBasesController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  new_action.before do
    @item_base.granted_abilities = []
    if params[:image_id]
      image = Image.find params[:image_id]
      image.tag_list << "item"
      image.save
      @item_base.image = image
    end
  end
  
  show.before do
    @title = @item_base.name
  end

  create.before do
    @item_base.account = current_account
  end

  protected
  def collection
    ItemBase.all find_opts
  end

  def find_opts
    {
      :include => [:image, {:granted_abilities => :intrinsic_base}],
      :order => "name ASC",
    }
  end
end
