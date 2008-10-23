var MouseEventMapper = {
  mapMouseEvents: function(obj) {
    ['mousedown', 'mouseup', 'mousemove', 'mouseover', 'mouseout'].each(function(eventType) {
      if(obj[eventType]) {
        obj.element.observe(eventType, obj[eventType].bindAsEventListener(obj));
      }
    });
  }
};

var Pixel = Class.create(MouseEventMapper, {
  initialize: function(element, canvas) {
    this.element = $(element);
    this.canvas = canvas;
    this.mapMouseEvents(this);
  },
  
  mousedown: function(event) { 
    this.canvas.tool.mousedown(event);
  },
  
  mousemove: function(event) { 
    this.canvas.tool.mousemove(event);
  }  
});

var Tool = Class.create({
  initialize: function() {  },  
  mousedown: function(event) {  },
  mouseup: function(event) {  },
  mousemove: function(event) {  },
  canvasout: function(event) {  }
});

var EyeDropper = Class.create(Tool, {
  mousedown: function(event) {
    //alert('Pre-parse: ' + event.element().style.backgroundColor);
    //alert(this.parseColor(event.element().style.backgroundColor));
    color = this.parseColor(event.element().style.backgroundColor) || 'FFFFFF';
    $('current_color').value = color;
    $('current_color').onblur();
  },
  
  parseColor: function(colorString) {
    if(!colorString) {
      return false
    }
    
    var bits = /^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$/.exec(colorString);
    return [
      this.toHex(bits[1]),
      this.toHex(bits[2]),
      this.toHex(bits[3])
    ].join('').toUpperCase();
  },  
  toHex: function(bits) {
    s = parseInt(bits).toString(16);
    if(s.length == 1) {
      s = '0' + s
    }
    return s;
  }
});

var dropper = new EyeDropper();

var Pencil = Class.create(Tool, {
  mousedown: function(event) {
    this.active = true;
    event.stop();
    return false;
  },
  
  mouseup: function(event) {
    this.active = false;
  },
  
  mousemove: function(event) {
    if(this.active) {
      event.element().style.backgroundColor = '#' + $F('current_color');
      event.element().style.backgroundImage = 'none';
    }
  },
  
  canvasout: function(event) {
    this.active = false;
  }
});
var pencil = new Pencil();

var Eraser = Class.create(Tool, {
  
  mousedown: function(event) {
    this.active = true;
  },
  mouseup: function(event) {
    this.active = false;
  },
  
  mousemove: function(event) {
    if(this.active) {
      event.element().style.backgroundColor = null;
      event.element().style.backgroundImage = null;
    }
  },
  
  canvasout: function(event) {
    this.active = false;
  }
});
var eraser = new Eraser();

var Canvas = Class.create({
  initialize: function(element) {
    this.element = $(element);
    //this.element.observe('mousedown', this.mousedown);
    this.element.observe('mouseup', this.mouseup.bindAsEventListener(this));
    this.element.observe('mouseout', this.mouseout.bindAsEventListener(this));
    this.tool = pencil;
  },
  
  mousedown: function(event) {
    
  },
  
  mouseup: function(event) {
    this.tool.mouseup(event);
  },
  
  mouseout: function(event) {
    console.log('canvasout');
    //this.tool.canvasout(event);
  },
  
  setTool: function(tool) {
    this.tool = tool;
  }  
});