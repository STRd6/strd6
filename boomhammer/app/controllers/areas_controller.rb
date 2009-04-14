class AreasController < ResourceController::Base
  actions :show, :index

  before_filter :character_required

  show.before do
    @title = @area.name
  end
end
