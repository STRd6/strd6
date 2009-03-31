class ImagesController < ResourceController::Base
  actions :all, :except => :destroy

  layout 'draw'

  skip_before_filter :verify_authenticity_token
end
