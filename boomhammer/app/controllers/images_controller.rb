class ImagesController < ResourceController::Base
  actions :all, :except => :destroy

  layout 'draw'
end
