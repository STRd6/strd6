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

        render :nothing => true
      end
    end
  end
end
