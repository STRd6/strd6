module DataMeister
  def self.populate
    berry = ItemBase.create :name => "berry",
      :description => "This berry looks delicious."
    coin = ItemBase.create :name => "coin",
      :description => "This coin looks delicious."
    magic_water = ItemBase.create :name => "magic water",
      :description => "This magic water looks delicious."

    plains = AreaBase.create :name => "plains",
      :description => "Grassland as far as the eye can see!"

    bush = OpportunityBase.create :name => "bush",
      :description => "Looks like a pretty standard bush.",
      :loots => [
        berry.loot_entry(50),
        coin.loot_entry(50),
      ]

    invisible_magic_well = OpportunityBase.create :name => "hidden magic well",
      :description => "Most people don't seem to notice this well...",
      :loots => [
        coin.loot_entry(1),
        magic_water.loot_entry(99),
      ]

    tor = plains.spawn :name => "Tor"
    Opportunity.create :opportunity_base => bush, :area => tor
    tyr = plains.spawn :name => "Tyr"
    Opportunity.create :opportunity_base => bush, :area => tyr
    Opportunity.create :opportunity_base => invisible_magic_well, :area => tyr

    tor.add_bi_directional_link_to tyr

    account = Account.create
    character = Character.create :name => "Moo II", :account => account

    2.times do
      character.take_opportunity(character.area.opportunities.first)
    end
  end
end
