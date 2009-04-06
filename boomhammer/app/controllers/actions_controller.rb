# This guy handles all those crazy non-resource oriented character actions!
class ActionsController < ApplicationController
  def equip_item
    item = Item.find(params[:item_id])
    slot = params[:item_slot].to_i

    set_game_notice current_character.equip(item, slot)

    redirect_to current_character
  end

  def take_opportunity
    opportunity = current_character.area.opportunities.find(params[:opportunity_id])
    set_game_notice current_character.take_opportunity(opportunity)

    redirect_to current_character.area
  end

  def take_area_link
    area_link = current_character.area.area_links.find(params[:area_link_id])
    set_game_notice current_character.take_area_link(area_link)

    redirect_to current_character.area
  end

  def make_recipe
    recipe = Recipe.find(params[:recipe_id])
    set_game_notice current_character.make_recipe(recipe)

    redirect_to recipes_path
  end

  protected

  def set_game_notice(notifications)
    flash[:game_notice] = render_to_string :partial => 'game/game_notifications', :object => notifications
  end
end
