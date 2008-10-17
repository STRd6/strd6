// Game JS Logic

/**
 * Game area onClick event handler
 */
function game_click(event) {
  if($current_action == null) {
    return;
  }
  
  var position = relative_position(event, $('game'));
  var x = position.x;
  var y = position.y;
  
  switch($current_action.id) {
    case 'move_action':
      break;
    case 'sign_action':
      position.text = 'A testyoieu sign'
      create_sign(position);
      //position.merge({'text': 'This sign was created at: ' + x, + ', ' + y})
      break;
    default:
      alert("In a better world I'd " + $current_action.id + " at: " + x + ", " + y)
      break;
  }
}

function prepare_sign(position) {
  
}

/**
 * Blast an Ajax request off to tell the game to make a sign.
 * sends top as :top || :y
 * sends left as :left || :x
 */
function create_sign(options) {
  var params = {};
  params['sign[top]'] = options.top || options.y;
  params['sign[left]'] = options.left || options.x;
  params['sign[text]'] = options.text;
  params.authenticity_token = window._token;
  
  new Ajax.Request('/signs', {
    parameters: params
  });
}

// Item/Inventory Dragon Drop

/** 
 * Droppable evnet handler for inventory
 */
function item_dropped(item, drop, event) {
  // TODO: Store the previous item
  
  //console.log(Event.pointerX(event) + ", " + Event.pointerY(event));
  
  // Put the item into it's new home
  drop.insert(item.remove());
  
  item.style.top = "0px";
  item.style.left = "0px";
  
  item.should_revert = false;
  
  var data = item.id.split('_');
  
  // Send updated item info to server
  var params = {'item[id]': data.last(),
    'authenticity_token': window._token
  };
  
  new Ajax.Request('/game/get_item', {
    parameters: params
  });
}
/** 
 * Handle removing displayables
 */
function got_item(id, character_id) {
  if($character_id != character_id){
    Element.hide(id);
  }
}
/** 
 * Handle notification of new displayables
 */
function displayable_created(id, parent, top, left) {
  var element = $(id);
  
  if(element) {
    // The element exists, let's update
    
    $(parent).insert(element.remove());
    new Effect.Move(element, {x: left, y: top, mode: 'absolute' });
    element.show();
  } else {
    // Elemet does not exist, get it
    var params = {
      'id': id.split('_').last(),
      'class': 'Item', 
      'authenticity_token': window._token
    };
    new Ajax.Request('/game/get_displayable', {
      parameters: params
    });
  }  
}

// Game Window Feature Drag'n

/** 
 * Drop handler for Game area
 */
function feature_dropped(feature, drop, event) {
  //alert('X: ' + feature.style.left + ', Y: ' + feature.style.top);
  var pos = relative_position(event, drop);
  //console.log(pos.x + ", " + pos.y);
  
  feature.should_revert = false;
  
  drop.insert(feature.remove());
  
  feature.style.left = pos.x + "px";
  feature.style.top = pos.y + "px";
  
  var data = feature.id.split('_');
  
  var params = {
    'id': data.last(), 
    'class': data.first(), 
    'left': feature.style.left, 
    'top': feature.style.top, 
    'authenticity_token': window._token
  };
  
  new Ajax.Request('/game/feature_move', {
    parameters: params
  });
}
/** 
 * Drag start handler for displayables
 */
function drag_start(draggable, event) {
  draggable.element.should_revert = true; 
  
  if($current_action == null || $current_action.id != "move_action") {
    draggable.finishDrag(event, false);
  }
}
/** 
 * Revert callback for displayables
 */
function drag_revert(draggable) {
  var r = draggable.should_revert; 
  draggable.should_revert = false; 
  return r;
}

// Action Shizzy
/** Global to hold the element that is the current action */
$current_action = null;
/** 
 * Stores the given action element and updates the CSS class visuals
 */
function active_action(id) {
  // De-activate the existing action if present
  if($current_action) {
    $current_action.toggleClassName('active');
  }
  
  // Assign the new action and toggle it to active
  if($current_action = $(id)) {
    $current_action.toggleClassName('active');
  }
}