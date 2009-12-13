class TreeworldsController < ResourceController::Base
  actions :show, :index, :command

  before_filter :ensure_player, :except => :index

  helper_method :current_player

  show.wants.json { render :json => object.world_data }

  def command
    current_player.commands.create(params[:command].merge(:state => "active"))

    render :nothing => true
  end

  def chat
    render :juggernaut do |page|
      page.call :alert, "<b>#{current_player.name}:</b> #{h params[:message]}"
    end

    render :nothing => true
  end

  private
  def current_player
    @player
  end

  def ensure_player
    if player_id = session[:player_id]
      if @player = Player.find(player_id)
        @new_player = false
        return true
      end
    end

    session[:player_id] = (@player = Player.create(:treeworld => object, :x => 2, :y => 2)).id
    @new_player = true
  end
end
