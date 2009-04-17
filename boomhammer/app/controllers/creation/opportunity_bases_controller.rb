class Creation::OpportunityBasesController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  new_action.before do
    @object.requisites = []
  end

  create.before do
    # HAX: Nested assignment doesn't link these mofos up
    @opportunity_base.events.each do |event|
      event.owner = @opportunity_base
    end

    @opportunity_base.account = current_account
  end

  protected

  def collection
    OpportunityBase.all :order => "name", :include => {:events => {:base => :image}}
  end
end
