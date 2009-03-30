class RecipesController < ResourceController::Base
  actions :show, :index

  before_filter :character_required

  show.before do
    @title = "Recipes!"
  end
end
