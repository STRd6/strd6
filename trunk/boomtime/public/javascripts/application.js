// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Window Dragon
function end_drag(element) {
  raise(element);
  store_position(element);
}

function store_position(element) {
  params = {'element': element.id, 
    'left': element.style.left, 'top': element.style.top, 
    'authenticity_token': window._token
  };
  
  new Ajax.Request('/users/store_position', {
    onComplete:function(request){}, 
    parameters: params
  });
  
  return false;
}

function raise(element) {
  
}

// Item/Inventory Dragon Drop

function item_dropped(item, drop) {
  // TODO: Store the previous item
  
  // Put the item into it's new home
  drop.insert(item.remove());
  
  // Send updated item info to server
  params = {'item[id]': item.id, 'item[owner_type]': 'otype', 'item[owner_id]': 'oid',
    'authenticity_token': window._token
  };
  
  new Ajax.Request('/users/store_position', {
    onComplete:function(request){}, 
    parameters: params
  });
}

// Game Window Feature Drag'n

function feature_dropped(feature, drop) {
  //alert('X: ' + feature.style.left + ', Y: ' + feature.style.top);
  feature.should_revert = false;
  
  data = feature.id.split('_');
  
  params = {
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

function drag_revert(draggable) {
  r = draggable.should_revert; 
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
// Scrolls the chat text window to the bottom
function scroll_chat() {
  data = $('chat_data');
  
  if(data) {
    chat_area = data.up('div');
    chat_area.scrollTop = chat_area.scrollHeight;
  }
}
