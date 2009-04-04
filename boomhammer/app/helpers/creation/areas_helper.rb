module Creation::AreasHelper
  def add_opportunity_link(form_builder)
    link_to_function 'Add an opportunity' do |page|
      form_builder.fields_for :opportunities, Opportunity.new(:opportunity_base => OpportunityBase.first), :child_index => 'NEW_RECORD' do |f|
        html = render(:partial => 'opportunity', :locals => { :form => f })
        page << "$('#opportunities').append('#{escape_javascript(html)}'.replace(/NEW_RECORD/g, new Date().getTime()));"
      end
    end
  end
end
