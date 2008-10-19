// Window Dragon
var Window = Class.create({
  initialize: function(element) {
    this.element = $(element);
    
    new Draggable(this.element, {
      handle: this.element.id + '_handle', 
      onEnd: this.onEnd.bindAsEventListener(this), 
      snap:[10,10]
    });
  },
  /** End drag event handler */
  onEnd: function() { 
    this.raise();
    this.storePosition(this.element);
  },
  /** Adjust the z-indexes of windows to raise this window to the top */
  raise: function() {
    // TODO
  },
  /** Send an Ajax request to store the position of this window */
  storePosition: function() {
    var params = {'element': this.element.id, 
      'left': this.element.style.left, 'top': this.element.style.top, 
      'authenticity_token': $token
    };

    new Ajax.Request('/users/store_position', {
      parameters: params
    });
  }
});

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
