class Creation::ActivitiesController < Creation::CreationController
  resource_controller
  actions :index

  protected
  def collection
    (
      AreaBase.all +
      ItemBase.all +
      OpportunityBase.all +
      Recipe.all
    ).sort_by(&:created_at).reverse
  end
end
