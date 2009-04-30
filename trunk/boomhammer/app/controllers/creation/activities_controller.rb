class Creation::ActivitiesController < Creation::CreationController
  resource_controller

  LEGIT = [ItemBase, AreaBase, OpportunityBase, Recipe, Image]

  actions :index

  index.wants.html do
    if params[:spartan]
      render :partial => "spartan_index"
    end
  end

  protected
  def collection
    entries =
      if type = params[:type]
        if (klass = type.constantize) && (LEGIT.include? klass)
          klass.all
        end
      else
        LEGIT.sum(&:all)
      end

    if entries
      entries.sort_by(&:created_at).reverse
    else
      []
    end
  end
end
