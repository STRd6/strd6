Factory.sequence :name do |i|
  "TEST_#{i}"
end

Factory.define :intrinsic_base do |intrinsic_base|
  intrinsic_base.name {Factory.next :name}
end

Factory.define :area_base do |area_base|
  area_base.name {Factory.next :name}
  area_base.description "Indescribable"
end

Factory.define :area do |area|
  area.association :area_base
  area.name {Factory.next :name}
end

Factory.define :area_link do |area_link|
  area_link.association :area
  area_link.linked_area {Factory(:area)}
end

Factory.define :item_base do |item_base|
  item_base.name {Factory.next :name}
  item_base.description "Indescribable"
end

Factory.define :item do |item|
  item.association :item_base
end

Factory.define :opportunity_base do |opportunity_base|
  opportunity_base.name {Factory.next :name}
  opportunity_base.description "Indescribable"
end

Factory.define :character do |character|
  character.name {Factory.next :name}
  character.association :area, :starting_location => true
  character.association :account
  character.actions 10000
end

Factory.define :account do |account|
  
end

Factory.define :recipe do |recipe|
  recipe.name {Factory.next :name}
end

Factory.define :recipe_component do |component|
  component.association :item_base
  component.association :recipe
end