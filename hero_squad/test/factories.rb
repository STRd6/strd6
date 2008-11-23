Factory.define :item do |item|
  item.name "Robe"
  item.base_uses 3
end

Factory.define :character do |c|
  c.name "Cleric"
  c.primary_item {|item| item.association :card }
  c.secondary_item {|item| item.association :card }
  c.hit_points 40
  c.energy 50
  c.actions 2
  c.base_stats({:str => 5, :dex => 5, :pow => 5})
end

Factory.define :ability do |ability|
  ability.name "Strike"
  ability.target_type Target::ANY
end

Factory.define :card do |card|
  card.game {|game| game.association :game}
  card.card_data {|d| d.association :item}
end

Factory.define :game do |game|
  
end