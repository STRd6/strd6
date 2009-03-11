module GamesHelper
  def actions_json(character)
    [{:name => "Strike", :index => 0}].to_json
    
    character.activated_abilities.inject([]) do |list, ability|
      list + [{:name => ability.name, :index => list.size}]
    end.to_json
  end
end
