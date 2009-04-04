Factory.sequence :name do |i|
  "TEST_#{i}"
end

Factory.define :intrinsic do |intrinsic|
  intrinsic.name {Factory.next :name}
end

Factory.define :area_base do |area_base|
  area_base.name {Factory.next :name}
  area_base.description "Indescribeable"
end

Factory.define :area do |area|
  area.association :area_base
  area.name {Factory.next :name}
end

Factory.define :area_link do |area_link|
  area_link.association :area
  area_link.linked_area {Factory(:area)}
end
