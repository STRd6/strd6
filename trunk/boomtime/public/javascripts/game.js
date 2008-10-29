var $character_id = -1;

var Player = Class.create({
  initialize: function() {
    this.abilities = {};
  },
  hasAbility: function(ability) {
    return this.abilities[ability] && (this.abilities[ability] > 0)
  },
  addAbility: function(ability) {
    this.abilities[ability] = (this.abilities[ability] || 0) + 1;
  },
  removeAbility: function(ability) {
    this.abilities[ability] = (this.abilities[ability] || 0) - 1;
  }  
});
var player = new Player();

var GameEntity = Class.create({
  initialize: function(element) {
    this.element = $(element);
    this.element.obj = this;
    
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
  initialize: function($super, element, ability) {
    $super(element);
    this.ability = ability || 'default'
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
    Droppables.add(this.element, {accept:['displayable'], hoverclass:'hover', onDrop:feature_dropped});

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
      case 'wood_action':
        this.create_wood(game_pos);
        break;
      default:
        alert("In a better world I'd " + $current_action.id + " at: " + x + ", " + y)
        break;
    }
  },
  
  /** Update the position of the displayable if it is present, otherwise
   * go to the server to get it.
   */
  updateDisplayable: function(id, x, y) {
    var element = $(id);
    
    if(element) { // The element exists, let's update
      this.element.insert(element.remove());
      new Effect.Move(id, {x: x, y: y, mode: "absolute" });
      element.show();
    } else { // Elemet does not exist, get it
      // TODO: Placeholder element to prevent loading twice? If so then use replace...
      //var place_holder = new Element('div', {'id': id, 'class': 'displayable'}).hide();
      //this.element.insert(top: place_holder);
      
      var klass$id = decompose_css_id(id);
      var params = {
        'id': klass$id[1],
        'class': klass$id[0],
        'authenticity_token': $token
      };
      
      new Ajax.Updater({success: this.element, failure: 'dcon'}, '/game/get_displayable', {
        parameters: params,
        evalScripts: true,
        insertion: 'top'
      });
    }
  },
  
  /** Remove displayable from game (hide it, stow it, axe it, whatev) */
  removeDisplayable: function(id) {
    $(id).hide();
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
  },
  
  /** Send request to create a wood pile to server. */
  create_wood: function(game_position) {
//    var item_create = $('item_create');
//
//    item_create.down('#item_top').value = game_position.y
//    item_create.down('#item_left').value = game_position.x
//
//    new Ajax.Request('/items', {asynchronous:true, evalScripts:true, parameters:Form.serialize($('new_item'))});
    if(player.hasAbility('chop')) {
      alert('Choppy choppy!');
    } else {
      alert('No chop for you!');
    }    
  }
});

/**
 * Inventory Slot: holds inventory items
 */
$total_inventory_slots = 0;
var InventorySlot = Class.create({
  initialize: function(element, item) {
    this.element = $(element);
    this.element.obj = this;
    this.container_position = $total_inventory_slots++;
    
    if(item) {
      this.insertItem(item);
    }
    
    Droppables.add(this.element, {
      accept: ['item'], 
      hoverclass: 'hover', 
      onDrop: this.onDrop
    });
  },
  
  insertItem: function(item) {
    item = $(item);
    // Store the previous item for swapping
    var prevItem = this.containedItem;
    var otherContainer = item.container;
    
    this._moveItem(item);
    
    if(otherContainer) {
      otherContainer.itemRemoved(item);
      if(prevItem) {
        this.itemRemoved(prevItem);
        otherContainer._moveItem(prevItem);
        otherContainer.itemAdded(prevItem);
      } else {
        otherContainer._clearItem();
      }
    } else { // Other item is probably from the ground
      // game.itemRemoved?
      if(prevItem) {
        this.itemRemoved(prevItem);
        game.element.insert(prevItem.remove());
        // game.itemAdded?
      }
    }
    
    this.itemAdded(item);
  },
  /** onDrop event handler */
  onDrop: function (item, drop, event) {
    // Put the item into it's new home
    drop.obj.insertItem(item);

    item.should_revert = false;

    var data = item.id.split('_');

    // Send updated item info to server
    var params = {'item[id]': data.last(),
      'item[container_position]': drop.obj.container_position,
      'authenticity_token': $token
    };

    new Ajax.Request('/game/get_item', {
      parameters: params
    });
  },
  
  _moveItem: function(item) {
    item.style.top = "0px";
    item.style.left = "0px";
    
    this.containedItem = item;
    this.element.insert(item.remove());
    item.container = this;
  },
  
  _clearItem: function() {
    this.containedItem = null;
  },
  
  /** Callback when an item is removed from this slot */
  itemRemoved: function(item) {
    
  },
  
  /** Callback when an item is added to this slot */
  itemAdded: function(item) {
    
  }
});

var ResourceDrop = Class.create(InventorySlot, {
  initialize: function($super, element) {
    this.element = $(element);
    this.element.obj = this;
    Droppables.add(this.element, {
      accept: ['pile'], 
      hoverclass: 'hover', 
      onDrop: this.onDrop
    });
  },
  /** onDrop event handler */
  onDrop: function (item, drop, event) {
    // Digest the resources
    drop.obj.insertItem(item);
    item.hide();
    item.should_revert = false;

    var data = item.id.split('_');

    // Send updated item info to server
    var params = {'item[id]': data.last(),
      'authenticity_token': $token
    };

    new Ajax.Request('/game/get_pile', {
      parameters: params
    });
  }
});

var EquipmentSlot = Class.create(InventorySlot, {
  initialize: function(element) {
    this.element = $(element);
    this.element.obj = this;
    Droppables.add(this.element, {
      accept: ['equipable'],
      hoverclass: 'hover',
      onDrop: this.onDrop
    });
  },
  
  onDrop: function(item, drop, event) {
    drop.obj.insertItem(item);
    item.should_revert = false;
    //alert(item + " confers " + item.obj.ability);
  },
  
  itemAdded: function(item) {
    player.addAbility(item.obj.ability)
  },
  
  itemRemoved: function(item) {
    player.removeAbility(item.obj.ability)
  }
});

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
  var pos = relative_position(event, drop);
  var offset = relative_position(event, feature);
  
  feature.should_revert = false;
  
  drop.insert(feature.remove());
  
  feature.style.left = pos.x - offset.x + "px";
  feature.style.top = pos.y - offset.y + "px";
  
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