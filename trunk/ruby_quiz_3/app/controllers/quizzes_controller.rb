class QuizzesController < ResourceController::Base
  actions :show, :index
  caches_page :show, :index
end
