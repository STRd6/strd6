class Command < ActiveRecord::Base
  include Locatable

  belongs_to :player

  def perform
    logger.info "#{player} Performed: #{command_type}"

    case command_type
    when "V_WALL"
      changed = player.build_wall_at(x, y, true)
    when "H_WALL"
      changed = player.build_wall_at(x, y, false)
    when "GET"
      #TODO
    end

    update_attribute :state, "complete"

    return changed
  end
end
