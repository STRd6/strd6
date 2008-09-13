require 'factory_girl'

Factory.define :character do |c|
  c.name 'A great character name'
end

Factory.define :faction do |f|
  f.name 'Great Faction'
end

Factory.define :area do |a|
  a.name 'Area 51'
end