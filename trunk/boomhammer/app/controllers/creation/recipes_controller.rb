class Creation::RecipesController < Creation::CreationController
  resource_controller
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
    @recipe.events.each do |event|
      event.owner = @recipe
    end

    @recipe.account = current_account
  end

  protected
  def object
    @object ||= Recipe.find(param, find_opts)
  end

  def collection
    Recipe.all find_opts
  end

  def find_opts
    {
      :include => [
        {:recipe_components => {:item_base => :image}},
        {:events => {:base => :image}},
      ],
      :order => "`recipes`.`name` ASC",
    }
  end
end