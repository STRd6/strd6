/*global jQuery */
(function($) {
  var actions = {
    clear: {
      name: "Clear Canvas",
      perform: function(canvas) {
        canvas.eachPixel(function(pixel) {
          pixel.color(null);
        });
      }
    },

    save: {
      name: "Download Image",
      perform: function(canvas) {
        document.location.href = 'data:image/octet-stream;base64,' + canvas.toBase64();
      }
    }
  };

  var CloneTool = function() {
    var cloneX, cloneY, targetX, targetY;

    return {
      name: "Clone",
      hotkeys: ['C'],
      icon: "/images/draw/clone.png",
      cursor: "url(/images/draw/clone.png) 0 0, default",
      mousedown: function(e) {
        if(e.shiftKey) {
          cloneX = this.x;
          cloneY = this.y;
        } else {
          targetX = this.x;
          targetY = this.y;
          var selection = this.canvas.getPixel(cloneX, cloneY);

          if(selection) {
            this.color(selection.color());
          }
        }
      },
      mouseenter: function(e) {
        var deltaX = this.x - targetX;
        var deltaY = this.y - targetY;
        var selection = this.canvas.getPixel(cloneX + deltaX, cloneY + deltaY);

        if(selection) {
          this.color(selection.color());
        }
      }
    };
  };

  var tools = {
    pencil: {
      name: "Pencil",
      hotkeys: ['P'],
      icon: "/images/draw/pencil.png",
      cursor: "url(/images/draw/pencil.png) 4 14, default",
      mousedown: function(e, color) {
        this.color(color);
      },
      mouseenter: function(e, color) {
        this.color(color);
      }
    },
    
    brush: {
      name: "Brush",
      hotkeys: ['B'],
      icon: "/images/draw/paintbrush.png",
      cursor: "url(/images/draw/paintbrush.png) 4 14, default",
      mousedown: function(e, color) {
        this.color(color);

        $.each(this.canvas.getNeighbors(this.x, this.y), function(i, neighbor) {
          if(neighbor) {
            neighbor.color(color);
          }
        });
      },
      mouseenter: function(e, color) {
        this.color(color);

        $.each(this.canvas.getNeighbors(this.x, this.y), function(i, neighbor) {
          if(neighbor) {
            neighbor.color(color);
          }
        });
      }
    },

    dropper: {
      name: "Dropper",
      hotkeys: ['I'],
      icon: "/images/draw/dropper.png",
      cursor: "url(/images/draw/dropper.png) 13 13, default",
      mousedown: function(e, currentColor, mode) {
        this.canvas.setColor(this.color(), mode);
        this.canvas.setTool(tools.pencil);
      }
    },

    eraser: {
      name: "Eraser",
      hotkeys: ['E'],
      icon: "/images/draw/eraser.png",
      cursor: "url(/images/draw/eraser.png) 4 11, default",
      mousedown: function() {
        this.color(null);
      },
      mouseenter: function() {
        this.color(null);
      }
    },

    fill: {
      name: "Fill",
      hotkeys: ['F'],
      icon: "/images/draw/fill.png",
      cursor: "url(/images/draw/fill.png) 12 13, default",
      mousedown: function(e, newColor, mode, pixel) {
        // Store original pixel's color here
        var originalColor = this.color();

        // Return if original color is same as currentColor
        if(newColor === originalColor) {
          return;
        }

        var q = new Array();
        pixel.color(newColor);
        q.push(pixel);

        while(q.length > 0) {
          pixel = q.pop();

          // Add neighboring pixels to the queue
          var neighbors = this.canvas.getNeighbors(pixel.x, pixel.y);

          $.each(neighbors, function(index, neighbor) {
            if(neighbor && neighbor.css("backgroundColor") === originalColor) {
              neighbor.color(newColor);
              q.push(neighbor);
            }
          });
        }
      }
    },

    clone: CloneTool()
  };

  var falseFn = function() {return false};
  var div = '<div></div>';
  var ColorPicker = function() {
    return $('<input></input>').addClass('color').colorPicker();
  };

  var rgbParser = /^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$/;
  
  $.fn.pixie = function(options) {
    
    options = options || {};
    var width = options.width || 16;
    var height = options.height || 16;
    var initializer = options.initializer;

    return this.each(function() {
      var pixie = $(div).addClass('pixie');
      var actionsMenu = $(div).addClass('actions');
      var canvas = $(div).addClass('canvas');
      var toolbar = $(div).addClass('toolbar');
      var colorbar = $(div).addClass('toolbar');
      
      function addAction(action) {
        actionsMenu.append(
          $("<a href='#' title='"+ action.name +"'>"+ action.name +"</a>")
            .addClass('tool')
            .bind("mousedown", function(e) {
              action.perform(canvas);
            })
            .click(falseFn)
        );
      }

      $.each(actions, function(key, action) {
        addAction(action);
      });

      var currentTool = undefined;
      var active = false;
      var mode = undefined;
      var primaryColorPicker = ColorPicker();
      var secondaryColorPicker = ColorPicker();

      colorbar.append(
        primaryColorPicker
      ).append(
        secondaryColorPicker
      );

      function addSwatch(color) {
        colorbar.append(
          $(div)
            .addClass('swatch')
            .css({backgroundColor: color})
            .bind('mousedown', function(e) {
              if(e.button === 0) {
                canvas.setColor(color, "P");
              } else {
                canvas.setColor(color, "S");
              }
            })
        );
      }

      $.each(["#000", "#FFF", "#666", "#CCC", "#800", "#080", "#008", "#880", "#808", "#088"], function(i, color) {
        addSwatch(color);
      });

      function setTool(tool) {
        currentTool = tool;
        if(tool.cursor) {
          pixie.css({cursor: tool.cursor});
        } else {
          pixie.css({cursor: "pointer"});
        }
      }

      function addTool(tool) {
        var alt = tool.name;

        if(tool.hotkeys) {
          alt += " ("+ tool.hotkeys +")";

          $(window).keydown(function(e) {
            if(tool.hotkeys[0].charCodeAt(0) == e.keyCode) {
              setTool(tool);
            }
          });
        }

        toolbar.append(
          $("<img src='"+ tool.icon +"' alt='"+ alt +"' title='"+ alt +"'></img>")
            .addClass('tool')
            .bind('mousedown', function(e) {
              setTool(tool);
            })
        );
      }

      setTool(tools.pencil);

      $.each(tools, function(key, tool) {
        addTool(tool);
      });

      var pixels = [];

      for(var row = 0; row < height; row++) {
        pixels[row] = [];
        for(var col = 0; col < width; col++) {
          var pixel = $(div).addClass('pixel');
          $.extend(pixel, {
            x: col,
            y: row,
            canvas: canvas,
            color: function(color) {
              if(arguments.length >= 1) {
                this.css("background-color", color);
                return this;
              } else {
                return this.css("background-color");
              }
            }
          });
          pixels[row][col] = pixel;
        }
      }

      for(row = 0; row < height; row++) {
        for(col = 0; col < width; col++) {
          (function(pixel) {
            pixel.bind("mousedown", function(e){
              active = true;
              if(e.button === 0) {
                mode = "P";
              } else {
                mode = "S";
              }
            });

            pixel.bind("mouseup", function(e) {
              active = false;
              mode = undefined;
            });

            pixel.bind("mousedown mouseup mouseenter", function(e) {
              if(active && currentTool && currentTool[e.type]) {
                var color;
                if(mode == "P") {
                  color = primaryColorPicker.css('backgroundColor');
                } else {
                  color = secondaryColorPicker.css('backgroundColor');
                }
                currentTool[e.type].call(pixel, e, color, mode, pixel);
              }
            });

            canvas.append(pixel);
          })(pixels[row][col]);
        }
        canvas.append('<div class="clear"></div>');
      }

      $.extend(canvas, {
        eachPixel: function(fn) {
          for(row = 0; row < height; row++) {
            for(col = 0; col < width; col++) {
              var pixel = pixels[row][col];
              fn.call(pixel, pixel, col, row);
            }
          }

          return canvas;
        },

        getPixel: function(x, y) {
          if(y >= 0 && y < height) {
            if(x >= 0 && x < width) {
              return pixels[y][x];
            }
          }

          return undefined;
        },
        
        getNeighbors: function(x, y) {
          return [
            this.getPixel(x+1, y),
            this.getPixel(x, y+1),
            this.getPixel(x-1, y),
            this.getPixel(x, y-1)
          ];
        },
        
        toHex: function(bits) {
          var s = parseInt(bits).toString(16);
          if(s.length == 1) {
            s = '0' + s
          }
          return s;
        },

        parseColor: function(colorString) {
          if(!colorString || colorString == "transparent") {
            return false;
          }

          var bits = rgbParser.exec(colorString);
          return [
            this.toHex(bits[1]),
            this.toHex(bits[2]),
            this.toHex(bits[3])
          ].join('').toUpperCase();
        },

        setColor: function(color, mode) {
          if(color[0] != "#") {
            color = this.parseColor(color) || "FFF";
          }

          if(mode == "S") {
            secondaryColorPicker.val(color);
            secondaryColorPicker[0].onblur();
          } else {
            primaryColorPicker.val(color);
            primaryColorPicker[0].onblur();
          }
        },
        
        addAction: addAction,

        addTool: addTool,

        setTool: setTool,

        toPNG: function() {
          var p = new Pnglet(width, height, 256);

          this.eachPixel(function(pixel, x, y) {
            if(pixel.css('backgroundColor') == "transparent") {
              p.point(p.color(0, 0, 0, 0), x, y);
            } else {
              var rgb = rgbParser.exec(pixel.css('backgroundColor'));
              p.point(p.color(rgb[1], rgb[2], rgb[3]), x, y);
            }
          });

          return p.output();
        },

        toBase64: function() {
          return base64Encode(this.toPNG()).gsub("\n", "");
        },

        toDataURL: function() {
          return 'url(data:image/png;base64,' + this.toBase64() + ')';
        }
      });

      if(initializer) {
        initializer(canvas);
      }

      pixie
        .bind('contextmenu', falseFn)
        .append(actionsMenu)
        .append(toolbar)
        .append(canvas)
        .append(colorbar)
        .append("<div class='clear'><div>");

      $(this).append(pixie);
    });
  };
})(jQuery);