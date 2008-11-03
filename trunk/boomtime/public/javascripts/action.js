/** Global to hold the element that is the current action */
$current_action = null;

var Action = Class.create({
  initialize: function(name){
    this.element = $(name + '_action');
    this.element.observe('click', activeAction.curry(this));
    this.id = this.element.id;
    this.action = this.actionMethods[name];
  },
  /** Prepares form values for submission. */
  prepareForm: function(type, params) {
    var form = $(type + '_create');
    
    $H(params).each(function(pair){
      form.down('#' + type + '_' + pair.key).value = pair.value;
    });
  },
  /** Hash of all the individual action methods. */
  actionMethods: {
    axe: function(gamePosition) {
      this.prepareForm('item', {
        top: gamePosition.y,
        left: gamePosition.x,
        prototype: 'axe'
      });

      new Ajax.Request('/items', {asynchronous:true, evalScripts:true, parameters:Form.serialize($('new_item'))});
    },
    /** Send request to create a new tree to server. */
    tree: function(gamePosition) {
      this.prepareForm('feature', {
        top: gamePosition.y,
        left: gamePosition.x
      });

      new Ajax.Request('/features', {asynchronous:true, evalScripts:true, parameters:Form.serialize($('new_feature'))});
    },
    /** Send request to create a wood pile to server. */
    wood: function(gamePosition) {
  //    var item_create = $('item_create');
  //
  //    item_create.down('#item_top').value = gamePosition.y
  //    item_create.down('#item_left').value = gamePosition.x
  //
  //    new Ajax.Request('/items', {asynchronous:true, evalScripts:true, parameters:Form.serialize($('new_item'))});
      if(player.hasAbility('chop')) {
        alert('Choppy choppy!');
      } else {
        alert('No chop for you!');
      }    
    },
    /** Prepare the form that creates signs. */
    sign: function(gamePosition, displayPosition) {
      var signCreate = $('sign_create');

      signCreate.down('#sign_top').value = gamePosition.y
      signCreate.down('#sign_left').value = gamePosition.x

      signCreate.show();
      center(signCreate, displayPosition);
    },
    
    move: function(gamePosition) {
      // Intentionally blank
    }
  }
});

/** Stores the current active action and updates the CSS class visuals. */
function activeAction(action) {
  // De-activate the existing action if present
  if($current_action) {
    $current_action.element.toggleClassName('active');
  }
  
  // Assign the new action and toggle it to active
  if($current_action = action) {
    $current_action.element.toggleClassName('active');
  }
}