class AreasController < ResourceController::Base
  actions :show, :index

  before_filter :character_required

  show.before do
    @title = @area.name
  end

  protected
  def object
    @object ||= Area.find(param, :include => [
      {:area_base => :image},
      {:opportunities => {:opportunity_base => [:image, :requisites]}},
      :shops,
      {:area_links => [:requisites, :linked_area]}
    ])
  end
end
