class TreeworldsController < ResourceController::Base
  actions :show, :index, :command

  before_filter :ensure_player, :except => :index

  helper_method :current_player

  show.wants.json { render :json => object.world_data }

  def command
    Command.transaction do
      current_player.commands.create(params[:command].merge(:state => "active"))
    end

    render :nothing => true
  end

  def chat
    render :juggernaut do |page|
      page.call :receiveChat, "<b>#{current_player.display_name}:</b> #{h params[:message]}"
    end

    render :nothing => true
  end

  private
  def current_player
    @player
  end

  def ensure_player
    if player_id = session[:player_id]
      if @player = Player.first(:conditions => {:id => player_id})
        @new_player = false
        return true
      end
    end

    @player = Player.create :treeworld => object, :x => rand(object.width), :y => rand(object.height)
    session[:player_id] = @player.id
    @new_player = true
  end
end
