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
  drop.insert(item.remove());
}
