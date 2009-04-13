class ShopsController < ResourceController::Base
  actions :show, :index, :edit

  before_filter :character_required
end
