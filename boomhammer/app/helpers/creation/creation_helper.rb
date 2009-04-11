module Creation::CreationHelper
  def chunked_index(collection)
    render :partial => 'creation/index', :locals => {:collection => collection}
  end

  def events_display(object)
    render :partial => 'creation/events_display', :locals => {:object => object}
  end

  def events_assist(form_builder)
    render :partial => 'creation/outcomes', :locals => { :form => form_builder}
  end
  
  def add_item_outcome_link(form_builder)
    link_to_function 'Add an item outcome' do |page|
      form_builder.fields_for :events, Event.new(:base => ItemBase.first), :child_index => 'NEW_RECORD' do |f|
        html = render(:partial => 'creation/event', :locals => { :form => f })
        page << "$('#outcomes').append('#{escape_javascript(html)}'.replace(/NEW_RECORD/g, new Date().getTime()));"
      end
    end
  end
end
