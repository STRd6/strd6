/** Global to hold the element that is the current action */
$current_action = null;

var Action = Class.create({
  initialize: function(element){
    this.element = $(element);
    this.element.observe('click', activeAction.curry(this));
    this.id = this.element.id;
  },  
  action: function(pos) {
    alert("Hi near " + pos.x + ", " + pos.y);
  }
});

/** 
 * Stores the given action element and updates the CSS class visuals
 */
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

function axeFunc(game_position) {
  var item_create = $('item_create');

  item_create.down('#item_top').value = game_position.y;
  item_create.down('#item_left').value = game_position.x;
  item_create.down('#item_prototype').value = 'axe';

  new Ajax.Request('/items', {asynchronous:true, evalScripts:true, parameters:Form.serialize($('new_item'))});
}