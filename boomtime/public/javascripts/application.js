// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Utility
function relative_position(event, element) {
  var abs_x = Event.pointerX(event);
  var abs_y = Event.pointerY(event);
  
  var elm_pos = element.cumulativeOffset();
  
  /*
  console.log("abs x: " + abs_x);
  console.log("abs y: " + abs_y);
  
  console.log("off x: " + elm_pos[0]);
  console.log("off y: " + elm_pos[1]);
  */
  
  var x = abs_x - elm_pos[0];
  var y = abs_y - elm_pos[1];
  
  return {x: x, y: y};
}

// Window Dragon
function end_drag(element) {
  raise(element);
  store_position(element);
}

function store_position(element) {
  var params = {'element': element.id, 
    'left': element.style.left, 'top': element.style.top, 
    'authenticity_token': window._token
  };
  
  new Ajax.Request('/users/store_position', {
    parameters: params
  });
  
  return false;
}

function raise(element) {
  
}

// Item/Inventory Dragon Drop

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

function got_item(id, character_id) {
  if($character_id != character_id){
    Element.hide(id);
  }
}

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

function drag_start(draggable, event) {
  draggable.element.should_revert = true; 
  
  if($current_action == null || $current_action.id != "move_action") {
    draggable.finishDrag(event, false);
  }
}

function drag_revert(draggable) {
  var r = draggable.should_revert; 
  draggable.should_revert = false; 
  return r;
}

// Action Shizzy
// Global to hold the element that is the current action
$current_action = null;

// Stores the given action element and updates the CSS class visuals
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


// Chat Party
function add_chat(message) {
  $('chat_data').insert({bottom: "<li>" + message + "</li>"});
  
  var should_scroll = true;
  // TODO: Only scroll if chat was previously at bottom
  if(should_scroll) scroll_chat();  
}

// Scrolls the chat text window to the bottom
function scroll_chat() {
  var data = $('chat_data');
  
  if(data) {
    var chat_area = data.up('div');
    chat_area.scrollTop = chat_area.scrollHeight;
  }
}
