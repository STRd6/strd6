function defaultParams(params) {
  return $H({'authenticity_token': AUTH_TOKEN}).merge(params);
}

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

var DropBase = Class.create({
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
  
  sendData: function(params) {
    new Ajax.Request(this.commandURL, {
      parameters: defaultParams(params)
    });
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