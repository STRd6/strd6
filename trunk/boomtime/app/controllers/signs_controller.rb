class SignsController < ResourceController::Base
  before_filter :login_required
  
  create.before do
    object.creator = active_character
  end
end
