/**
 * Signs are visible in areas. They are messages written by players.
 * This class handles initializing their state and setting up the mouse effects.
 */
var Sign = Class.create({
  initialize: function(element) {
    this.element = $(element);
    this.element.down('.overlay').hide();
    
    this.element.observe('mouseover', this.over.bindAsEventListener(this));
    this.element.observe('mouseout', this.out.bindAsEventListener(this));
  },
  
  /**
   * Mouse over event handler
   */
  over: function(event) {
    this.element.down('.overlay').appear({ duration: 0.34 });
  },
  
  /**
   * Mouse out event handler
   */
  out: function(event) {
    this.element.down('.overlay').fade();
  }
});