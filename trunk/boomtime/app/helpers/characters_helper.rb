module CharactersHelper
  ICOMAP = {:str => 'stars', :dex => 'red_black', :pow => 'flame_lamp'}
  
  def icon_for(key)
    image_tag "icons/#{ICOMAP[key]}.png", :class => 'icon'
  end
  
  def stats_text(character, stat)
    base = character.stats[stat]
    bonus = character.bonus[stat]
    total = base + bonus
    
    s = content_tag :span, total, :class => 'total'
    s += content_tag :span, base, :class => 'base' unless bonus == 0
    s += content_tag :span, "+#{bonus}", :class => 'bonus' if bonus > 0
    s += content_tag :span, bonus, :class => 'penalty' if bonus < 0
    s
  end
end
