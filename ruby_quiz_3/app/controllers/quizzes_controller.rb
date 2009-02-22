class QuizzesController < ResourceController::Base
  caches_page :show, :index
  
  before_filter :authenticate, :except => [ :show, :index ]
end
