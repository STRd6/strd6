Factory.sequence :item_name do |n|
  "Item_%03d" % n
end

Factory.define :item do |item|
  item.name {Factory.next :item_name}
  item.stat_mods({:pow => 2})
end

Factory.sequence :character_name do |n|
  "Character_%03d" % n
end

Factory.define :character do |c|
  c.name {Factory.next :character_name}
  c.base_stats({:str => 5, :dex => 5, :pow => 5, :move => 2, :hp_max => 50, :en_max => 40})
end

Factory.define :character_instance do |c|
  c.character {|character| character.association :character}
  c.game {|game| game.association :game}
  c.player {|player| player.association :player}
end

Factory.sequence :ability_name do |n|
  "Ability_%03d" % n
end

Factory.define :ability do |ability|
  ability.name {Factory.next :ability_name}
  ability.target_type Target::ANY
  ability.attribute_expressions({:energy_cost => '3', :damage => 'str/2 + 1.d(6)',})
  ability.activated true
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
  entry.game {|game| game.association :game}
  entry.player {|player| player.association :player}
  entry.position 0
end

Factory.define :card do |card|
  card.game Factory(:game)
  card.data {|d| d.association :item}
end