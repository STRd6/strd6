module RecipesHelper
  def draw_recipe(recipe)
    render :partial => 'recipes/recipe', :locals => {:recipe => recipe}
  end
end
