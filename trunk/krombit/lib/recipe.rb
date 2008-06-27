class Recipe
  @@data_dir = 'data/recipes/'
  
  attr_reader :ingredients, :products
  
  def initialize(ingredients, products)
    @ingredients = ingredients
    @products = products
  end
  
  def concoct_from(stockpile)
    stockpile.add products if stockpile.remove ingredients
  end
  
  def self.load(name)
    data = YAML::load(IO.read( @@data_dir + name + '.yml' ))
    return self.new(data['ingredients'], data['products'])
  end
  
end
