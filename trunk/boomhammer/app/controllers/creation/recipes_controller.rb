class Creation::RecipesController < ResourceController::Base
  actions :all, :except => :destroy

  show.before do
    @title = @recipe.name
  end

  create.before do
    # HAX: Nested assignment doesn't link these mofos up
    @recipe.recipe_components.each do |ingredient|
      ingredient.recipe = @recipe
    end
    # HAX: Nested assignment doesn't link these mofos up
    @recipe.recipe_outcomes.each do |outcome|
      outcome.recipe = @recipe
    end
  end
end