class Creation::ItemBasesController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  show.before do
    @title = @item_base.name
  end
end
