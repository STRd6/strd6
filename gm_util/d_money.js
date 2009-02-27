D$ = (function($) {
  var debug = true;

  var self = {
    error: function(message) {
      if(debug) {
        console.error(message);
      }
    },
    log: function(message) {
      if(debug) {
        console.log(message);
      }
    },
    injectResourceCSS: function (resources) {
      $.each(resources, function(index, resource) {
        var style = document.createElement('style');
        style.type = 'text/css';

        var css = GM_getResourceText (resource);
        style.innerHTML = css;
        $('head').append(style);
      });
    },
    debug: function (newValue) {
      if(newValue == undefined) {
        return debug;
      } else {
        debug = newValue;
        return self; // Let's allow chaining for no reason!
      }
    }
  };
  
  return self;
})(jQuery);

D$.Widget = function(options) {
  var cssClass = 'strd6-gm-widget';
  
  var defaults = {
    title: 'Widget',
    opacity: 0.75
  };
  
  var opts = $.extend(defaults, options);
  
  var chasis = $('<div></div>')
    .css({
      'z-index': '1000',
      position: 'absolute'
    })
    .fadeTo(0, opts.opacity)
    .bind('dragstart', function(event) {
      return $(event.target).is('.handle');
    })
    .bind('drag', function(event) {
      $(this).css({
        top: event.offsetY,
        left: event.offsetX
      });
    });
    
  var handle = $('<div>'+ opts.title +'</div>')
    .css({
      backgroundColor: 'blue',
      color: 'white',
      'font-family': 'Consolas,Monaco,Lucida Console,Liberation Mono,DejaVu Sans Mono,Bitstream Vera Sans Mono,Courier New',
      'font-weight': 'bold',
      'text-align': 'left',
      'min-width': 200,
      '-moz-border-radius': '4px 4px 0 0',
      'padding': '1px 4px'
    })
    .addClass(cssClass)
    .addClass('handle')
    .appendTo(chasis);
  
  return chasis;
};

//$('body').append(new Widget());