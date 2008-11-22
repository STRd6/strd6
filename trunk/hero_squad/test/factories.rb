Factory.define :item do |item|
  item.base_uses 3
end

Factory.define :character do |c|
  c.primary_item {|item| item.association :item }
  c.hit_points 40
  c.energy 50
  c.actions 2
  c.base_stats({:str => 5, :dex => 5, :pow => 5})
end