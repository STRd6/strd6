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
  }
});

var Hex = Class.create({
  initialize: function(element, row, col) {
    this.element = $(element);
    this.row = row;
    this.col = col;
    this.element.obj = this;
    
    console.log("Hex: " + this.row + ", " + this.col);
    
    Droppables.add(this.element, {
      accept: ['token'], 
      hoverclass: 'hover', 
      onDrop: this.onDrop
    });
  },
  
  onDrop: function(item, drop, event) {
    var hex = drop.obj;
    item.shouldRevert = false;
    hex._moveItem(item);
    console.log("Dropped on: " + hex.row + ", " + hex.col);
  },
  
  _moveItem: function(item) {
    item.style.top = "0px";
    item.style.left = "0px";
    
    this.element.insert(item.remove());
  }
});