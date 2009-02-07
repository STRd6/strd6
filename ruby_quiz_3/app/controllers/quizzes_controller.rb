class QuizzesController < ResourceController::Base
  actions :show, :index, :new, :edit, :update, :create
  
  caches_page :index
  caches_page :show
  
  before_filter :authenticate, :except => [ :index , :show ]
end
