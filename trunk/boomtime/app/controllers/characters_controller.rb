class CharactersController < ApplicationController
  before_filter :login_required
  
  def index
    user = current_user
    @characters = user.characters if user
  end
end
