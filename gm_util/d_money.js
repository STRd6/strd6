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