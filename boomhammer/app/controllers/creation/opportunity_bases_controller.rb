class Creation::OpportunityBasesController < ResourceController::Base
  actions :all, :except => :destroy

  create.before do
    # HAX: Nested assignment doesn't link these mofos up
    @opportunity_base.loots.each do |loot|
      loot.opportunity_base = @opportunity_base
    end
  end
end