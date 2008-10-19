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
    'authenticity_token': $token
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
