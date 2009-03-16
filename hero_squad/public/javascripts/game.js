var targeting = false;

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

var commando = new Ajaxer();
commando.play = function() {
  this.sendData(null, '/games/play')
};

var Game = Class.create(Ajaxer, {
  initialize: function(element) {
  },
  
  characterAction: function(characterId, ability) {
    if(this.selectedCharacter && this.target) {
      var params = {
        'x': this.target.row, 'y': this.target.col, 
        'character_instance[id]': characterId,
        'ability_index': ability.index,
        'ability_name': ability.name
      };

      this.sendData(params, '/games/character_action/' + gameId);
    }
  },
  
  setTargetHex: function(hex) {
    if(this.target) {
      this.target.deselect();
    }
    this.target = hex;
    if(this.target) {
      this.target.select();
    }
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
  initialize: function($super, element, abilities) {
    $super(element);
    var id = element.split('_').last();
    this.element.objectId = id;
    this.element.observe('mouseover', function() {
      if(!targeting) {
        $$('.character_instance').invoke('hide');
        $('character_instance_' + id).show();
        game.selectedCharacter = this;
      }
    }.bind(this));
    
    var menuItems = [];
    
    abilities.each(function(ability) {
      menuItems.push({
        name: ability.name,
        className: ability.name,
        callback: function() {
          game.characterAction(id, ability);
        }
      });
    });
    
    new Proto.Menu({
      selector: '#' + this.element.id,
      className: 'menu desktop', // this is a class which will be attached to menu container (used for css styling)
      menuItems: menuItems // array of menu items
    })

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
      onDrop: this.onDrop.bind(this)
    });
  },
  
  process: function(droppable) {
    
  },
  
  onDrop: function(item, drop, event) {    
    item.shouldRevert = false;
    
    var target = drop.obj;
    target._insertItem(item);
    this.process(item.obj);
    
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
  
  process: function(card) {
    card.equipped = true;
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
  commandData: function(token) {
    return {
      'id': gameId,
      'token[id]': token.objectId,
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
    
    this.element.observe('click', this.onClick.bindAsEventListener(this));
  },
  
  onClick: function(event) {
    game.setTargetHex(this);
  },
  
  deselect: function() {
    this.element.removeClassName('target');
  },
  
  select: function() {
    this.element.addClassName('target');
  }
});