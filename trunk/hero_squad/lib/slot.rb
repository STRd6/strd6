# All about the valid slots on a character that can contain cards
module Slot
  NONE = 0
  
  ABILITY_1 = 1
  ABILITY_2 = 2
  ABILITY_3 = 3

  ABILITIES = [ABILITY_1, ABILITY_2, ABILITY_3]

  ITEM_PRIMARY = 4
  ITEM_SECONDARY = 5
  
  ALL = [ITEM_PRIMARY, ITEM_SECONDARY, ABILITY_1, ABILITY_2, ABILITY_3]
  
  DISPLAY_CLASS = {
    ABILITY_1 => 'ability',
    ABILITY_2 => 'ability',
    ABILITY_3 => 'ability',
    ITEM_PRIMARY => 'primary',
    ITEM_SECONDARY => 'secondary',
  }
end