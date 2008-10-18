/** 
 * Returns {x: x, y: y} where the x and y values are the mouse offsets 
 * within the element, for the specified event.
 */
function relative_position(event, element) {
  var abs_x = Event.pointerX(event);
  var abs_y = Event.pointerY(event);
  
  var elm_pos = element.cumulativeOffset();
  
  /*
  console.log("abs x: " + abs_x);
  console.log("abs y: " + abs_y);
  
  console.log("off x: " + elm_pos[0]);
  console.log("off y: " + elm_pos[1]);
  */
  
  var x = abs_x - elm_pos[0];
  var y = abs_y - elm_pos[1];
  
  return {x: x, y: y};
}

/** 
 * Returns {x: x, y: y} where the x and y values are the absolute mouse offsets 
 * for the specified event.
 */
function absolute_position(event) {
  return {x: Event.pointerX(event), y: Event.pointerY(event)}
}

/**
 * Listener to stop event propagation.
 * Stops the event and returns false.
 */
function stop(event) {
  Event.stop(event); 
  return false;
}

/**
 * Centers the element at position.
 * element can be a string id or an extended element.
 * position is an object with properties top and left or x and y.
 */
function center(element, position) {
  element = $(element);
  element.style.top = ((position.top || position.y) - element.offsetHeight/2) + 'px';
  element.style.left = ((position.left || position.x) - element.offsetWidth/2) + 'px';
}