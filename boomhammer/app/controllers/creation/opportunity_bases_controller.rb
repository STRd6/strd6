class Creation::OpportunityBasesController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  new_action.before do
    @object.requisites = []
  end

  create.before do
    # HAX: Nested assignment doesn't link these mofos up
    @opportunity_base.loots.each do |loot|
      loot.opportunity_base = @opportunity_base
    end
  end

  protected

  def collection
    OpportunityBase.all :order => "name", :include => {:loots => {:item_base => :image}}
  end
end
