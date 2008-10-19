var $character_id = -1;

var GameEntity = Class.create({
  initialize: function(element) {
    this.element = $(element);
    
    new Draggable(this.element, {revert: this.revert, onStart: this.start})
  },  
  
  /** Drag start handler */
  start: function (draggable, event) {
    draggable.element.should_revert = true; 

    if($current_action == null || $current_action.id != "move_action") {
      draggable.finishDrag(event, false);
    }
  },
  /** Revert callback */
  revert: function (draggable) {
    return draggable.should_revert; 
  }
});

var Character = Class.create(GameEntity, {
  initialize: function($super, element) {
    $super(element);
  }
});

var Item = Class.create(GameEntity, {
  initialize: function($super, element) {
    $super(element);
  }
});

var Feature = Class.create(GameEntity, {
  initialize: function($super, element) {
    $super(element);
  }
});

var Game = Class.create({
  initialize: function(element) {
    this.element = $(element);
    Droppables.add(this.element, {accept:['displayable'], hoverclass:'hover', onDrop:feature_dropped})

    this.element.observe('click', this.click.bindAsEventListener(this));
  },
  
  /** onClick event handler */
  click: function(event) {
    if($current_action == null) {
      return;
    }

    var game_pos = relative_position(event, $('game'));
    var x = game_pos.x;
    var y = game_pos.y;

    switch($current_action.id) {
      case 'move_action':
        break;
      case 'sign_action':
        this.prepare_sign(game_pos, relative_position(event, $('content')));
        break;
      case 'tree_action':
        this.create_tree(game_pos);
        break;
      default:
        alert("In a better world I'd " + $current_action.id + " at: " + x + ", " + y)
        break;
    }
  },
    
  updateDisplayable: function(id, x, y) {
    var element = $(id);
    
    if(element) { // The element exists, let's update
      this.element.insert(element.remove());
      new Effect.Move(id, {x: x, y: y, mode: "absolute" });
      element.show();
    } else { // Elemet does not exist, get it
      // TODO: Placeholder element to prevent loading twice?
      
      var klass$id = decompose_css_id(id);
      var params = {
        'id': klass$id[1],
        'class': klass$id[0],
        'authenticity_token': $token
      };
      
      new Ajax.Updater({ success: this.element, failure: 'dcon' }, '/game/get_displayable', {
        parameters: params,
        insertion: Insertion.Top
      });
    }
  },

  /** Prepare the form that creates signs. */
  prepare_sign: function(game_position, display_position) {
    var sign_create = $('sign_create');

    sign_create.down('#sign_top').value = game_position.y
    sign_create.down('#sign_left').value = game_position.x

    sign_create.show();
    center(sign_create, display_position);
  },

  /** Send request to create a new tree to server. */
  create_tree: function(game_position) {
    var feature_create = $('feature_create');

    feature_create.down('#feature_top').value = game_position.y
    feature_create.down('#feature_left').value = game_position.x

    new Ajax.Request('/features', {asynchronous:true, evalScripts:true, parameters:Form.serialize($('new_feature'))});
  }
});

// Item/Inventory Dragon Drop

/** 
 * Droppable evnet handler for inventory
 */
function item_dropped(item, drop, event) {
  // TODO: Store the previous item
  
  //console.log(Event.pointerX(event) + ", " + Event.pointerY(event));
  
  // Put the item into it's new home
  drop.insert(item.remove());
  
  item.style.top = "0px";
  item.style.left = "0px";
  
  item.should_revert = false;
  
  var data = item.id.split('_');
  
  // Send updated item info to server
  var params = {'item[id]': data.last(),
    'authenticity_token': $token
  };
  
  new Ajax.Request('/game/get_item', {
    parameters: params
  });
}
/** 
 * Handle removing displayables
 */
function got_item(id, character_id) {
  if($character_id != character_id){
    Element.hide(id);
  }
}

// Game Window Feature Drag'n

/** 
 * Drop handler for Game area
 */
function feature_dropped(feature, drop, event) {
  //alert('X: ' + feature.style.left + ', Y: ' + feature.style.top);
  var pos = relative_position(event, drop);
  //console.log(pos.x + ", " + pos.y);
  
  feature.should_revert = false;
  
  drop.insert(feature.remove());
  
  feature.style.left = pos.x + "px";
  feature.style.top = pos.y + "px";
  
  var data = feature.id.split('_');
  
  var params = {
    'id': data.last(), 
    'class': data.first(), 
    'left': feature.style.left, 
    'top': feature.style.top, 
    'authenticity_token': $token
  };
  
  new Ajax.Request('/game/feature_move', {
    parameters: params
  });
}

// Action Shizzy
/** Global to hold the element that is the current action */
$current_action = null;
/** 
 * Stores the given action element and updates the CSS class visuals
 */
function active_action(id) {
  // De-activate the existing action if present
  if($current_action) {
    $current_action.toggleClassName('active');
  }
  
  // Assign the new action and toggle it to active
  if($current_action = $(id)) {
    $current_action.toggleClassName('active');
  }
}