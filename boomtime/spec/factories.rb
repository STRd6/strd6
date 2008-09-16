require 'factory_girl'

Factory.define :character do |c|
  c.name 'A great character name'
end

Factory.define :faction do |f|
  f.name 'Great Faction'
end

Factory.sequence :area_name do |n|
  " Area 5#{n}"
end

Factory.define :area do |a|
  a.name { Factory.next :area_name }
end

Factory.define :feature do |f|
  f.name 'Feature 51'
end

Factory.define :adjacency do |a|
  a.area { Factory :area }
  a.adjacent_area { Factory :area }
end

Factory.sequence :item_name do |n|
  " Item 5#{n}"
end

Factory.define :item do |i|
  i.name { Factory.next :item_name }
end

Factory.define :user do |u|
  u.login 'quire'
  u.email 'quire@example.com'
  u.password 'quire69'
  u.password_confirmation 'quire69'
end