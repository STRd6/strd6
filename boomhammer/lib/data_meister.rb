module DataMeister
  def self.populate
    berry = ItemBase.create :name => "berry",
      :description => "This berry looks delicious."
    coin = ItemBase.create :name => "coin",
      :description => "This coin looks delicious."
    gem = ItemBase.create :name => "gem",
      :description => "This gem looks delicious."
    magic_water = ItemBase.create :name => "magic water",
      :description => "This magic water looks delicious."
    rain_water = ItemBase.create :name => "rain water",
      :description => "This rain water looks delicious."
    wookie_droppings = ItemBase.create :name => "wookie droppings",
      :description => "These wookie droppings look delicious."
    thunder = ItemBase.create :name => "thunder",
      :description => "This thunder looks delicious."

    plains = AreaBase.create :name => "plains",
      :description => "Grassland as far as the eye can see!"
    cloud_city = AreaBase.create :name => "cloud city",
      :description => "Clouds as far as the eye can see!"

    bush = OpportunityBase.create :name => "bush",
      :description => "Looks like a pretty standard bush.",
      :loots => [
        berry.loot_entry(50),
        wookie_droppings.loot_entry(3),
        coin.loot_entry(50),
      ]

    invisible_magic_well = OpportunityBase.create :name => "hidden magic well",
      :description => "Most people don't seem to notice this well...",
      :loots => [
        coin.loot_entry(1),
        wookie_droppings.loot_entry(1),
        gem.loot_entry(9),
        magic_water.loot_entry(99),
      ],
      :requisites => [:see_invisible]

    cantina = OpportunityBase.create :name => "cantina",
      :description => "Oona goota, Solo?",
      :loots => [
        coin.loot_entry(25),
        wookie_droppings.loot_entry(75),
      ],
      :requisites => [:charisma]

    cumulonimbus = OpportunityBase.create :name => "cumulonimbus",
      :description => "Cumulonimbus (Cb) is a type of cloud that is tall, dense, and involved in thunderstorms and other intense weather. It is a result of atmospheric instability. These clouds can form alone, in clusters, or along a cold front in a squall line. They create lightning throught the heart of the cloud.",
      :loots => [
        rain_water.loot_entry(50),
        wookie_droppings.loot_entry(1),
        thunder.loot_entry(99),
      ]

    tor = plains.spawn :name => "Tor", :starting_location => true
    Opportunity.create :opportunity_base => bush, :area => tor
    Opportunity.create :opportunity_base => cantina, :area => tor
    tyr = plains.spawn :name => "Tyr", :starting_location => true
    Opportunity.create :opportunity_base => bush, :area => tyr
    Opportunity.create :opportunity_base => invisible_magic_well, :area => tyr
    bespin = cloud_city.spawn :name => "Bespin"
    Opportunity.create :opportunity_base => cantina, :area => bespin
    Opportunity.create :opportunity_base => cumulonimbus, :area => bespin

    tor.add_bi_directional_link_to tyr
    tor.add_bi_directional_link_to bespin, :requisites => [:flight]
    tyr.add_bi_directional_link_to bespin, :requisites => [:flight]

    account = Account.create
    character = Character.create :name => "Moo II", :account => account, :intrinsics => {:flight => true, :charisma => true}

    2.times do
      character.take_opportunity(character.area.opportunities.first)
    end
  end
end
