// Window Dragon
var Window = Class.create({
  initialize: function(element) {
    this.element = $(element);
    
    new Draggable(this.element, {
      handle: this.element.id + '_handle', 
      onEnd: this.onEnd.bindAsEventListener(this), 
      snap:[10,10]
    });
    
    // Controls the minimizing/resoring of windows
    // NEED to do this better - just select title_bar_icon regardless of expansion state
    titleBarIcon = this.element.select('div[class="title_bar_icon expanded"]')[0];    
    if(titleBarIcon) {
      titleBarIcon.observe('click', this.toggleCollapse.bindAsEventListener(this));
      console.log("Observing " + titleBarIcon.toString());
    }
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
  },
  
  // Minimizes or restores the window to be or not be just the title bar
  // TODO: make the styles look better when minimized, AJAX the state of minimization, fix divs whose widths are based on the elements inside them
  toggleCollapse: function() {
    var windowDiv = this.element.select('div[class="window"]')[0];
    // This shit is lame, make it better
    if(!windowDiv) {
      windowDiv = this.element.select('div[class="window collapsed"]')[0];
    }
    
    // If it's collapsed, expand it. Else collapse it.
    if(windowDiv.hasClassName("collapsed")) {
      windowDiv.removeClassName("collapsed");
      // DO BETTER - titleBarIcon should be out of if statements
      var titleBarIcon = this.element.select('div[class="title_bar_icon collapsed"]')[0];
      titleBarIcon.removeClassName("collapsed");
      titleBarIcon.addClassName("expanded");
    }
    else {
      windowDiv.addClassName("collapsed");
      // DO BETTER
      var titleBarIcon = this.element.select('div[class="title_bar_icon expanded"]')[0];
      titleBarIcon.removeClassName("expanded");
      titleBarIcon.addClassName("collapsed");
    }
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
  var cnt = db.execute('select count(*) from Chat');
  var rs = db.execute('select * from Chat order by Timestamp limit 10 offset ' + (cnt.field(0) - 10));

function checkTime(i) {
  if (i<10) {
    i="0" + i;
  }
return i;
}

  while (rs.isValidRow()) {
    var t = new Date(rs.field(1));
    t = checkTime(t.getHours()) + ':' + checkTime(t.getMinutes()) + ':' + checkTime(t.getSeconds());
    $('chat_data').insert({bottom: "<li>" + t + ' ' + rs.field(0) + "</li>"});
    rs.next();
  }
  rs.close();
  scroll_chat();
}

function addChatToDB(msg) {
  db.execute('insert into Chat values (?, ?)', [msg, new Date().getTime()]);
}
