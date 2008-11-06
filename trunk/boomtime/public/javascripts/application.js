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
  addChatToDB(message);
  var should_scroll = true;
  // TODO: Only scroll if chat was previously at bottom
  if(should_scroll) scroll_chat();  
}

function addEvent(message) {
  $('game_data').insert({top: "<li>" + message + "</li>"});
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

var db = google.gears.factory.create('beta.database');
db.open('database-chat');
db.execute('create table if not exists Chat' +
           ' (Phrase text, Timestamp int)');

function loadChatsFromDB() {
  var rs = db.execute('select * from Chat order by Timestamp');

  while (rs.isValidRow()) {
    //alert(rs.field(0) + '@' + rs.field(1));
    var t = new Date(rs.field(1));
    //t = (t.getMonth() + 1) +'/' + t.getDate() + '/' +  (t.getYear() + 1900) + ' ' + 
    t = t.getHours() + ':' + t.getMinutes() + ':' + t.getSeconds();
    $('chat_data').insert({bottom: "<li>" + t + ' ' + rs.field(0) + "</li>"});
    rs.next();
  }
  rs.close();
  scroll_chat();
}

function addChatToDB(msg) {
  db.execute('insert into Chat values (?, ?)', [msg, new Date().getTime()]);
}
