module CharactersHelper
  def actions_remaining_for(character)
    if character.actions > 0
      "#{character.actions} actions remaining"
    else
      "No actions remaining"
    end
  end
end
