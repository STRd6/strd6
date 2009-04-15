# This guy handles all those crazy non-resource oriented account actions!
class MetaController < ApplicationController
  before_filter :login_required

  def vote
    image = Image.find(params[:image_id])
    case params[:commit]
    when "+"
      image.vote_up(current_account)
    when "-"
      image.vote_down(current_account)
    else
      raise "Unknown vote shiznat"
    end

    redirect_to :back
  end
end
