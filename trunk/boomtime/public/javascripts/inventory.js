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
