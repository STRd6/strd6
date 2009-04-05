class Creation::AreasController < Creation::CreationController
  resource_controller
  actions :all, :except => :destroy

  create.before do
    # HAX: Nested assignment doesn't link these mofos up
    @area.opportunities.each do |opportunity|
      opportunity.area = @area
    end
  end
end
