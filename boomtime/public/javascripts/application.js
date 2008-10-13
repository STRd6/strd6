// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Utility
/** 
 * Returns {x: x, y: y} where the x and y values are the mouse offsets 
 * within the element, for the specified event.
 */
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
/** 
 * End drag event handler for windows
 */
function end_drag(element) {
  raise(element);
  store_position(element);
}
/** 
 * Send an Ajax request to store the position of the given window
 */
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
/** 
 * Adjust the z-indexes of windows to raise the given window to the top
 */
function raise(element) {
  
}

// Chat Party
/** 
 * Append a chat message to the chat window and scroll if necessary
 */
function add_chat(message) {
  $('chat_data').insert({bottom: "<li>" + message + "</li>"});
  
  var should_scroll = true;
  // TODO: Only scroll if chat was previously at bottom
  if(should_scroll) scroll_chat();  
}
/** 
 * Scrolls the chat text window to the bottom
 */
function scroll_chat() {
  var data = $('chat_data');
  
  if(data) {
    var chat_area = data.up('div');
    chat_area.scrollTop = chat_area.scrollHeight;
  }
}
