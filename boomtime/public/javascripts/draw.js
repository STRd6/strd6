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
  canvasout: function(event) {  },
  cursor: "pointer",
  id: ""
});

// Array to hold a reference to each tool
var tools = new Array();

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
  },
  
  cursor: "crosshair", // make custom cursor
  id: "dropper"
});

var dropper = new EyeDropper();
tools[tools.length] = dropper;

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
      setPixelColor(event.element(), '#' + $F('current_color'));
    }
  },
  
  canvasout: function(event) {
    this.active = false;
  },
  
  cursor: "move",
  id: "pencil"
});

var pencil = new Pencil();
tools[tools.length] = pencil;

var Eraser = Class.create(Tool, {
  
  mousedown: function(event) {
    this.active = true;
  },
  mouseup: function(event) {
    this.active = false;
  },
  
  mousemove: function(event) {
    if(this.active) {
      setPixelColor(event.element(), null);
    }
  },
  
  canvasout: function(event) {
    this.active = false;
  },
  
  cursor: "n-resize", // make custom cursor
  id: "eraser"
});

var eraser = new Eraser();
tools[tools.length] = eraser;

var Fill = Class.create(Tool, {
  // Uses breadth first search graph traversal to get all adjacent pixels
  mouseup: function(event) {
    // Store original pixel's color here
    var originalColor = event.element().style.backgroundColor;
    
    var q = new Array();
    q.push(event.element());
    
    while(q.length > 0) {
      var pixel = q.pop();
      setPixelColor(pixel, '#' + $F('current_color'));
      pixel.addClassName("visited");
      
      // Add neighboring pixels to the queue
      var coords = this.getCoordinates(pixel);
      var neighbors = this.getNeighbors(coords[0], coords[1]);

      neighbors.each(function(neighbor) {
        if(neighbor != null && !neighbor.hasClassName("visited") && 
        neighbor.style.backgroundColor == originalColor) {
           q.push(neighbor);
        }
      });
    }

    // Remove "visited" class from all pixels
    canvas.element.select('[class="pixel visited"]').each(function(pixel) {
      pixel.removeClassName("visited");
    });
  },
  
  // Returns the x, y coordinates of pixel
  getCoordinates: function(pixel) {
    var x = pixel.id.toString().indexOf("_");
    var y = pixel.id.toString().indexOf("_", x + 1);
    x = parseInt(pixel.id.toString().slice(x + 1, y));
    y = parseInt(pixel.id.toString().slice(y + 1));
    return [x, y];
  },
  
  // Returns the pixel element with the x, y coordinates passed to it
  getPixelByCoordinates: function(x, y) {
    return $("p_" + x + "_" + y);
  },
  
  // Returns an array of the pixels who neighbor the pixel at coordinates x, y
  getNeighbors: function(x, y) {
    return [this.getPixelByCoordinates(x+1, y), 
            this.getPixelByCoordinates(x, y+1),
            this.getPixelByCoordinates(x-1, y),
            this.getPixelByCoordinates(x, y-1)];
  },
  
  // Why does the URL not work? it is a mystery to me...
  cursor: "url(../images/draw/fill.png)", //'url("../images/draw/fill.png")', //"e-resize", // make custom
  id: "fill"
});

var fill = new Fill();
tools[tools.length] = fill;

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
    //console.log('canvasout');
    //this.tool.canvasout(event);
  },
  
  setTool: function(tool) {
    this.tool = tool;
    this.element.style.cursor = tool.cursor;
    console.log(this.element.style.cursor);
    
    // Adds set_tool class to style currently selected tool
    this.removeSetToolClasses();
    $(this.tool.id).addClassName("set_tool");
  },
  
  // Removes the "set_tool" class name from each tool
  removeSetToolClasses: function() {
    tools.each(function(tool) {
      $(tool.id).removeClassName("set_tool");
    });
  },
  
  // Removes the color from all pixels
  clearCanvas: function() {
    this.element.select('[class="pixel"]').each(function(pixel) {
      setPixelColor(pixel, null);
    });
  }
});

/* Sets the pixels background color to the color passed to it
 * 'color' must be a properly formatted hexadecimal string or null
 */
function setPixelColor(pixel, color) {
  pixel.style.backgroundColor = color;
  if(color == null)
    pixel.style.backgroundImage = null;
  else
    pixel.style.backgroundImage = 'none';
}
