var MouseEventMapper = {
  mapMouseEvents: function(obj) {
    ['mousedown', 'mouseup', 'mousemove', 'mouseover', 'mouseout', 'contextmenu'].each(function(eventType) {
      if(obj[eventType]) {
        obj.element.observe(eventType, obj[eventType].bindAsEventListener(obj));
      }
    });
  }
};

var Pixel = Class.create(MouseEventMapper, {
  initialize: function(element, canvas, x, y) {
    this.element = $(element);
    this.element.pixel = this;
    this.canvas = canvas;
    this.mapMouseEvents(this);
    this.x = x;
    this.y = y;
    this.canvas.registerPixel(this, x, y);
  },
  
  contextmenu: function(event) { 
    event.stop(); 
  },
  
  mousedown: function(event) { 
    this.canvas.tool.mousedown(event);
  },
  
  mousemove: function(event) { 
    this.canvas.tool.mousemove(event);
  },
  
  /** Sets the pixel's color to the given color. */
  setColor: function(color) {
    this.element.style.backgroundColor = color;
    this.element.style.backgroundImage = 'none';
  },
  
  /** Clears the pixel's color.  */
  clear: function() {
    this.element.style.backgroundColor = null;
    this.element.style.backgroundImage = null;
  },
  
  /** Returns true if this pixel is clear (empty, fully transparent) */
  isClear: function() {
    return !this.element.style.backgroundColor;
  },
  
  color: function() {
    return this.element.style.backgroundColor;
  },
  
  rgb: function() {
    return bits = /^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$/.exec(this.element.style.backgroundColor);
  }
});

// NOTE: Eraser and dropper tools don't work in Opera (Mac)

var Tool = Class.create({
  initialize: function() {  },  
  mousedown: function(event) {  },
  mouseup: function(event) {  },
  mousemove: function(event) {  },
  canvasout: function(event) {  },
  cursor: "default",
  id: "",
  
  currentColor: function(event) {
    if(!event || event.isLeftClick()) {
      return $F('left_color');
    } else {
      return $F('right_color');
    }
  },
  
  toHex: function(bits) {
    var s = parseInt(bits).toString(16);
    if(s.length == 1) {
      s = '0' + s
    }
    return s;
  },
  
  parseColor: function(colorString) {
    if(!colorString) {
      return false;
    }
    
    var bits = /^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$/.exec(colorString);
    return [
      this.toHex(bits[1]),
      this.toHex(bits[2]),
      this.toHex(bits[3])
    ].join('').toUpperCase();
  }
});

// Array to hold a reference to each tool
var tools = new Array();

var EyeDropper = Class.create(Tool, {
  mousedown: function(event) {
    color = this.parseColor(event.element().style.backgroundColor) || 'FFFFFF';
    
    if(event.isLeftClick()) {
      $('left_color').value = color;
      $('left_color').onblur();
    } else {
      $('right_color').value = color;
      $('right_color').onblur();
    }
  },
  
  cursor: "url(../images/draw/dropper.png) 13 13, default", // works in Safari but not FF/OP
  id: "dropper"
});

var dropper = new EyeDropper();
tools[tools.length] = dropper;

var Pencil = Class.create(Tool, {
  /** Activate and store the current color based on which mouse button was 
   * pressed and color the pixel.
   */
  mousedown: function(event) {
    this.active = true;
    this._myCurrentColor = this.currentColor(event);
    event.element().pixel.setColor('#' + this._myCurrentColor);
  },
  /** De-activate */
  mouseup: function(event) {
    this.active = false;
  },
  /** Color the pixel if active (mousedown) */
  mousemove: function(event) {
    if(this.active) {
      event.element().pixel.setColor('#' + this._myCurrentColor);
    }
  },
  /** De-activate when cursor exits the canvas */
  canvasout: function(event) {
    this.active = false;
  },
  
  cursor: "url(../images/draw/pencil.png) 4 14, default", // works in Safari but not FF/OP
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
      event.element().pixel.clear();
    }
  },
  
  canvasout: function(event) {
    this.active = false;
  },
  
  cursor: "url(../images/draw/eraser.png) 4 11, default", // works in Safari but not FF/OP
  id: "eraser"
});

var eraser = new Eraser();
tools[tools.length] = eraser;

var Fill = Class.create(Tool, {
  
  // Uses breadth first search graph traversal to get all adjacent pixels
  mouseup: function(event) {
    t1 = new Date();
    // Store original pixel's color here
    var originalColor = event.element().style.backgroundColor;
    var newColor = this.currentColor(event);
    
    // Return if original color is same as currentColor
    if(newColor === this.parseColor(originalColor)) {
      return;
    }    
    
    var q = new Array();
    q.push(event.element().pixel);
    
    while(q.length > 0) {
      var pixel = q.pop();
      pixel.setColor('#' + newColor);
      
      // Add neighboring pixels to the queue
      var neighbors = canvas.getNeighbors(pixel.x, pixel.y);

      neighbors.each(function(neighbor) {
        if(neighbor && neighbor.color() == originalColor) {
           q.push(neighbor);
        }
      });
    }
    
    console.log(new Date() - t1);
  },
  
  cursor: "url(../images/draw/fill.png) 12 13, default", // works in Safari but not FF/OP
  id: "fill"
});

var fill = new Fill();
tools[tools.length] = fill;

var Canvas = Class.create({
  initialize: function(element, width, height) {
    this.element = $(element);
    //this.element.observe('mousedown', this.mousedown);
    this.element.observe('mouseup', this.mouseup.bindAsEventListener(this));
    this.element.observe('mouseout', this.mouseout.bindAsEventListener(this));
    this.tool = pencil;
    this.width = width;
    this.height = height;
    
    this._initPixelArrays();
  },
  
  _initPixelArrays: function() {
    var pixels = new Array(this.width);
    $R(0, this.width - 1).each(function(i){
      pixels[i] = new Array(this.height);
    });
    
    this.pixels = pixels;
  },
  
  registerPixel: function(pixel, x, y) {
    this.pixels[x][y] = pixel;
  },
  
  /** Returns an array of the pixels who neighbor the pixel at coordinates x, y */
  getNeighbors: function(x, y) {
    return [this.getPixel(x+1, y), 
            this.getPixel(x, y+1),
            this.getPixel(x-1, y),
            this.getPixel(x, y-1)];
  },
  
  /** Returns the pixel element with the x, y coordinates passed to it */
  getPixel: function(x, y) {
    if(x >= 0 && x < this.width) {
      if(y >= 0 && y < this.height) {
        return this.pixels[x][y];
      }
    }
    
    return null;
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
  
  _toPNG: function() {
    var w = this.width;
    var h = this.height;
    var p = new Pnglet(w, h, 256);
    var c = this;
    
    $R(0, h - 1).each(function(y){
      $R(0, w - 1).each(function(x) {
        var pixel = c.getPixel(x,y);
        if(pixel.isClear()) {
          p.point(p.color(0, 0, 0, 0), x, y);
        } else {
          var rgb = pixel.rgb();
          p.point(p.color(rgb[1], rgb[2], rgb[3]), x, y);
        }
      });      
    });
    
    return p.output();
  },
  
  toDataURL: function() {
    return 'url(data:image/png;base64,' + base64Encode(this._toPNG()).gsub("\n", "") + ')';
  },
  
  preview: function() {
    $('sample').style.backgroundImage = this.toDataURL();
  },
  
  saveFile: function() {
    document.location.href = 'data:image/octet-stream;base64,' + base64Encode(this._toPNG()).gsub("\n", "");
  },
  
  setTool: function(tool) {
    this.tool = tool;
    this.element.style.cursor = tool.cursor;
    
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
  // NOTE: does not work in FF/OP on Mac
  clearCanvas: function() {
    this.element.select('[class="pixel"]').each(function(element) {
      element.pixel.clear();
    });
  }
});
