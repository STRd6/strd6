class Description
  def initialize
    @feeling = self.class.feelings.random
    @view_verb = self.class.view_verb.random
    @adjective = self.class.adjectives.random
    @characteristic = self.class.characteristics.random
    @feature = self.class.features.random
    @noun = self.class.nouns.random
    @descrip = self.class.descrip_style.random
  end

  def describe
    return eval(@descrip) + "\n"
  end

  def self.adjectives
    ['accursed', 'cramped', 'damp', 'dank', 'dark', 'dimly lit', 'granite', 'labrynthine']
  end

  def self.view_verb
    ['witness', 'come across', 'stumble upon', 'see', 'behold']
  end

  def self.view_verb_past
    ['witnessed', 'came across', 'stumbled upon', 'saw', 'beheld']
  end

  def self.features
    ['a long wall of piled skeletons, with casks and puncheons intermingling', 'a great oaken cask', 'an ancient fallen weapon rack; inscribed on the stand is the phrase "nemo me impune lacessit"', 'a coat of arms depicting a huge human foot d\'or, in a field azure; the foot is crushing a serpent rampant whose fangs are imbedded in the heel', 'a stark pile of human remains', 'several unlabled barrels of wine; their age is uncertain', 'a narrow enclosure, beneath the dust is written "in pace requiescat", squinting within you see the shadowy outlines of bones']
  end

  def self.characteristics
    ['a rough hewn stone floor', 'an unusually low ceiling']
  end

  def self.feelings
    ['chill', 'haunting feeling', 'wave of despair', 'feeling of immense terror']
  end

  def self.nouns
    ['alcove', 'hallway', 'room', 'cavern']
  end

  def self.door_descrip
    ['a stone archway', 'a wooden door', 'a small opening']
  end

  def self.descrip_style
    ['"You #{@view_verb} #{@feature}."',
     '"Upon entering this #{@noun} you #{@view_verb} #{@feature}."',
     '"This #{@adjective} #{@noun} gives you a #{@feeling}."',
     '"#{@characteristic} spans this #{@adjective} #{@noun}."',
     '"Looking around this #{@adjective} #{@noun} you encounter #{@feature}."',
     '"This #{@adjective} #{@noun} is otherwise non-descript."',
     '"The #{@adjective} #{@noun} you have entered contains #{@feature}."',
     '"A #{@feeling} overcomes you as you #{@view_verb} #{@feature}."']
  end

  def self.feeling_style
    ['"You are struck by a sudden #{@feeling}."',
     '"There must be some way out of this #{@adjective} place!"']
  end
end
