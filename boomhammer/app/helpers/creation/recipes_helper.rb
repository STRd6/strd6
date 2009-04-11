module Creation::RecipesHelper
  def add_ingredient_link(form_builder)
    link_to_function 'Add an ingredient' do |page|
      form_builder.fields_for :recipe_components, RecipeComponent.new(:item_base => ItemBase.first), :child_index => 'NEW_RECORD' do |f|
        html = render(:partial => 'ingredient', :locals => { :form => f })
        page << "$('#ingredients').append('#{escape_javascript(html)}'.replace(/NEW_RECORD/g, new Date().getTime()));"
      end
    end
  end
end
