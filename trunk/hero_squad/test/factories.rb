Factory.define :item do |item|
  item.name "Robe"
  item.base_uses 3
  item.stat_mods({})
end

Factory.define :character do |c|
  c.name "Cleric"
  c.base_stats({:str => 5, :dex => 5, :pow => 5, :move => 2, :max_hp => 50, :max_en => 40})
end

Factory.define :ability do |ability|
  ability.name "Strike"
  ability.target_type Target::ANY
  ability.attribute_expressions({:energy_cost => '3', :damage => '1',})
end

Factory.sequence :player_name do |n|
  "Player_%03d" % n
end

Factory.define :player do |player|
  player.name {Factory.next :player_name}
end

Factory.sequence :game_name do |n|
  "Game_%03d" % n
end

Factory.define :game do |game|
  game.name {Factory.next :game_name}
end

Factory.define :game_entry do |entry|
  entry.game Factory(:game)
  entry.player {|player| player.association :player}
  entry.position 0
end

Factory.define :card do |card|
  card.game Factory(:game)
  card.data {|d| d.association :item}
end