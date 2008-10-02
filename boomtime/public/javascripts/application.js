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

function feature_dropped(feature, drop) {
  //alert('X: ' + feature.style.left + ', Y: ' + feature.style.top);
  
  params = {'id': feature.id.split('_').last(), 'left': feature.style.left, 'top': feature.style.top, 
    'authenticity_token': window._token
  };
  
  new Ajax.Request('/game/feature_move', {
    parameters: params
  });
}
