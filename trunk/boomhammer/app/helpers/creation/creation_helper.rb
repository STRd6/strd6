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
    add_event_link(form_builder, 'Add an item outcome', ItemBase)
  end

  def add_opportunity_outcome_link(form_builder)
    add_event_link(form_builder, 'Add an outcome that creates an opportunity', OpportunityBase)
  end

  def add_area_outcome_link(form_builder)
    add_event_link(form_builder, 'Add an outcome that creates an area', AreaBase)
  end

  def add_event_outcome_link(form_builder)
    add_event_link(form_builder, 'Add an outcome that creates an event', EventBase)
  end

  def add_event_link(form_builder, text, base_class)
    link_to_function text do |page|
      form_builder.fields_for :events, Event.new(:base => base_class.first), :child_index => 'NEW_RECORD' do |f|
        html = render(:partial => 'creation/event', :locals => { :form => f })
        page << "$('#outcomes').append('#{escape_javascript(html)}'.replace(/NEW_RECORD/g, new Date().getTime()));"
      end
    end
  end

  def editability_drop_down(form)
    form.label(:editability, "Editable by") +
    form.collection_select(:editability, Editable::Editability.values, :to_s, :name)
  end

  def equip_drop_down(form)
    form.label(:allowed_slot, "Equip on") +
    form.collection_select(:allowed_slot, Item::EquipSlot.values, :to_s, :display_name)
  end
end
