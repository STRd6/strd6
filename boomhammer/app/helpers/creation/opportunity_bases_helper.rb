module Creation::OpportunityBasesHelper
  def add_loot_link(form_builder)
    link_to_function 'Add an outcome' do |page|
      form_builder.fields_for :loots, Loot.new(:item_base => ItemBase.first), :child_index => 'NEW_RECORD' do |f|
        html = render(:partial => 'loot', :locals => { :form => f })
        page << "$('#outcomes').append('#{escape_javascript(html)}'.replace(/NEW_RECORD/g, new Date().getTime()));"
      end
    end
  end
end
