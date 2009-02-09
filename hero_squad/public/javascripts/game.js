var Ajaxer = Class.create({
  sendData: function(params, commandURL) {
    // Use the default command url if none passed in
    commandURL = commandURL || this.commandURL;
    
    // Make the Ajax request with default parameters (auth token, etc.)
    new Ajax.Request(commandURL, {
      parameters: this.defaultParams(params)
    });
  },
  
  defaultParams: function defaultParams(params) {
    return $H({'authenticity_token': AUTH_TOKEN}).merge(params);
  }
});

var Game = Class.create(Ajaxer, {
  initialize: function(element) {
  },
  
  characterAction: function() {
    var params = {
      'x': 1, 'y': 5, 
      'character_instance[id]': 1,
      'ability_id': 0,
      'ability_name': 'Strike'
    };
    
    this.sendData(params, '/games/character_action/' + gameId);
  }
});

var GameEntity = Class.create({
  initialize: function(element) {
    this.element = $(element);
    this.element.obj = this;
    
    new Draggable(this.element, {revert: this.revert, onStart: this.start})
  },  
  
  /** Drag start handler */
  start: function (draggable, event) {
    draggable.element.shouldRevert = true; 

//    if($current_action == null || $current_action.id != "move_action") {
//      draggable.finishDrag(event, false);
//    }
  },
  /** Revert callback */
  revert: function (draggable) {
    return draggable.shouldRevert; 
  }
});

var Token = Class.create(GameEntity, {
  initialize: function($super, element) {
    $super(element);
    this.element.objectId = element.split('_').last();
  }
});

var Card = Class.create(GameEntity, {
  initialize: function($super, element) {
    $super(element);
    this.element.objectId = element.split('_').last();
  }
});

var DropBase = Class.create(Ajaxer, {
  initialize: function(element) {
    this.element = $(element);
    this.element.obj = this;
    
    Droppables.add(this.element, {
      accept: this.accept,
      hoverclass: 'hover',
      onDrop: this.onDrop
    });
  },
  
  onDrop: function(item, drop, event) {
    item.shouldRevert = false;
    
    var target = drop.obj;
    target._insertItem(item);
    
    target.sendData(target.commandData(item));
  },
  
  _insertItem: function(item) {
    item.style.top = "0px";
    item.style.left = "0px";
    
    this.element.insert(item.remove());
  }
});

var Slot = Class.create(DropBase, {
  accept: ['card'],
  commandURL: '/games/assign_card/1',
  commandData: function(item) {
    return {
      'character_instance[id]': this.characterInstanceId,
      'slot': this.slot,
      'card[id]': item.objectId
    }
  },
  
  initialize: function($super, element) {
    $super(element);
    
    ids = element.split('_');
    
    this.characterInstanceId = ids[1];
    this.slot = ids[2];
  }
});

var Hex = Class.create(DropBase, {
  accept: ['token'],
  commandURL: '/games/move_character/1',
  commandData: function(item) {
    return {
      'id': gameId,
      'token[id]': item.objectId,
      'x': this.row,
      'y': this.col
    };
  },
  
  initialize: function($super, element, row, col) {
    $super(element);
    
    this.row = row;
    this.col = col;
    
    Droppables.add(this.element, {
      accept: ['token'], 
      hoverclass: 'hover', 
      onDrop: this.onDrop
    });
  }
});