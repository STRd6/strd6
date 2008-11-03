module ObjectController
  include Renderino
  
  def self.included(base)
    base.class_eval do
      before_filter :login_required
      actions :all, :except => [:destroy]

      create.before do
        object.creator = active_character
        object.area = active_character.area if active_character
      end
      
      create.wants.js do
        element = render_to_string :partial => 'game/displayable_content', :locals => {:displayable => object}

        render_to_area(object.area) do |page|
          page.insert_html :top, 'game', element
          page.call "new #{object.class.name}", object.css_id
        end
        
        render :update do |page|
          page.replace 'active_character_data', :partial => 'components/active_character_data', :locals => {:active_character => active_character}
        end
      end
      
      create.failure.wants.js do
        render :update do |page|
          page.alert object.errors
        end
      end
    end
  end
end
