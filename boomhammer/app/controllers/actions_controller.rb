# This guy handles all those crazy non-resource oriented character actions!
class ActionsController < ApplicationController
  def equip_item
    item = Item.find(params[:item_id])
    slot = params[:item_slot].to_i

    set_game_notice current_character.equip(item, slot)

    redirect_to current_character
  end

  def unequip_item
    item = Item.find(params[:item_id])

    set_game_notice current_character.unequip(item)

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
    set_game_notice current_character.make_recipe(recipe, params[:params])

    redirect_to :back
  end

  def add_shop_item
    shop = current_character.shops.find(params[:shop_id])
    item = current_character.items.find(params[:item_id])
    price = params[:price].to_i

    shop.add_shop_item(item, price)

    redirect_to :back
  end

  def remove_shop_item
    shop = current_character.shops.find(params[:shop_id])
    set_game_notice shop.remove_shop_item(params[:shop_item_id])

    redirect_to :back
  end

  def purchase
    shop = Shop.find(params[:shop_id])

    set_game_notice(
      if shop.area == current_character.area
        shop.purchase(current_character, params[:shop_item_id], params[:quantity].to_i)
      else
        {:status => "You do not appear to have access to that shop from your current situation"}
      end
    )

    redirect_to :back
  end

  def remove_shop_inventory
    shop = Shop.find(params[:shop_id])

    set_game_notice shop.remove_inventory(params[:item_id])

    redirect_to :back
  end

  protected

  def set_game_notice(notifications)
    flash[:game_notice] = render_to_string :partial => 'game/game_notifications', :object => notifications
  end
end
