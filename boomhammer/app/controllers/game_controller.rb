class GameController < ApplicationController
  def index
    @title = "Welcome"

    if logged_in?
      if current_character
        redirect_to current_character.area
      elsif current_account.characters.size > 0
        redirect_to characters_path
      else
        redirect_to new_character_path
      end
    else
      render :action => :welcome
    end
  end
end
