class Creation::ItemBasesController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  new_action.before do
    @object.granted_abilities = []
  end
  
  show.before do
    @title = @item_base.name
  end
end
