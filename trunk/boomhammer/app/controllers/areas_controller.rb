class AreasController < ResourceController::Base
  actions :show, :index

  show.before do
    @title = @area.name
  end
end
