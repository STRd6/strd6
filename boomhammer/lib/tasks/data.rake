namespace :data do
  desc "Populate sample app data"
  task :populate => :environment do
    account = Account.create

    character = Character.create :name => "Moo II", :account => account

    berry = ItemBase.create :name => "berry",
      :description => "This berry looks delicious."
    coin = ItemBase.create :name => "coin",
      :description => "This coin looks delicious."

    plains = AreaBase.create :name => "plains",
      :description => "Grassland as far as the eye can see!"
    
    bush = OpportunityBase.create :name => "bush",
      :description => "Looks like a pretty standard bush.",
      :loots => [
        Loot.new(:item_base => berry, :weight => 50),
        Loot.new(:item_base => coin, :weight => 50)
      ]

    tor = plains.spawn :name => "Tor"
    opportunity = Opportunity.create :opportunity_base => bush, :area => tor
    tyr = plains.spawn :name => "Tyr"
    opportunity = Opportunity.create :opportunity_base => bush, :area => tyr

    tor.add_bi_directional_link_to tyr
  end
end