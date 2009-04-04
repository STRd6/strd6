class Creation::RecipesController < ResourceController::Base
  actions :all, :except => :destroy

  show.before do
    @title = @recipe.name
  end
end