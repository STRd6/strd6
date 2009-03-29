class ItemBasesController < ResourceController::Base
  actions :show, :index

  show.before do
    @title = @item_base.name
  end
end
