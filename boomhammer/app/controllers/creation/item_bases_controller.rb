class Creation::ItemBasesController < ResourceController::Base
  actions :all, :except => :destroy

  show.before do
    @title = @item_base.name
  end
end
