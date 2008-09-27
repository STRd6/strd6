module CharactersHelper
  ICOMAP = {:str => 'stars', :dex => 'red_black', :pow => 'flame_lamp'}
  
  def icon_for(key)
    image_tag "icons/#{ICOMAP[key]}.png", :class => 'icon'
  end
end
