// ==UserScript==
// @name           GreasyThug - Annotations
// @namespace      http://strd6.com
// @description    Super-simple website annotations shared with all!
// @include        *
//
// @resource       jQuery               http://ajax.googleapis.com/ajax/libs/jquery/1.3.1/jquery.min.js
// @resource       jQueryUI             http://strd6.com/stuff/jqui/jquery-ui-personalized-1.6rc6.min.js
//
// @resource       jQueryUICSS          http://strd6.com/stuff/jqui/theme/ui.all.css
//
// @resource    ui-bg_diagonals-thick_18_b81900_40x40.png       http://strd6.com/stuff/jqui/theme/images/ui-bg_diagonals-thick_18_b81900_40x40.png
// @resource    ui-bg_glass_100_f6f6f6_1x400.png                http://strd6.com/stuff/jqui/theme/images/ui-bg_glass_100_f6f6f6_1x400.png
// @resource    ui-bg_diagonals-thick_20_666666_40x40.png       http://strd6.com/stuff/jqui/theme/images/ui-bg_diagonals-thick_20_666666_40x40.png
// @resource    ui-bg_glass_65_ffffff_1x400.png                 http://strd6.com/stuff/jqui/theme/images/ui-bg_glass_65_ffffff_1x400.png
// @resource    ui-bg_gloss-wave_35_f6a828_500x100.png          http://strd6.com/stuff/jqui/theme/images/ui-bg_gloss-wave_35_f6a828_500x100.png
// @resource    ui-icons_222222_256x240.png                     http://strd6.com/stuff/jqui/theme/images/ui-icons_222222_256x240.png
// @resource    ui-bg_flat_10_000000_40x100.png                 http://strd6.com/stuff/jqui/theme/images/ui-bg_flat_10_000000_40x100.png
// @resource    ui-icons_ef8c08_256x240.png                     http://strd6.com/stuff/jqui/theme/images/ui-icons_ef8c08_256x240.png
// @resource    ui-icons_ffd27a_256x240.png                     http://strd6.com/stuff/jqui/theme/images/ui-icons_ffd27a_256x240.png
// @resource    ui-bg_glass_100_fdf5ce_1x400.png                http://strd6.com/stuff/jqui/theme/images/ui-bg_glass_100_fdf5ce_1x400.png
// @resource    ui-icons_228ef1_256x240.png                     http://strd6.com/stuff/jqui/theme/images/ui-icons_228ef1_256x240.png
// @resource    ui-icons_ffffff_256x240.png                     http://strd6.com/stuff/jqui/theme/images/ui-icons_ffffff_256x240.png
// @resource    ui-bg_highlight-soft_75_ffe45c_1x100.png        http://strd6.com/stuff/jqui/theme/images/ui-bg_highlight-soft_75_ffe45c_1x100.png
// @resource    ui-bg_highlight-soft_100_eeeeee_1x100.png       http://strd6.com/stuff/jqui/theme/images/ui-bg_highlight-soft_100_eeeeee_1x100.png

// ==/UserScript==

/** -GreasyThug-
 *  
 *  I've been called a greasy thug, too. It never stops hurting. 
 *  So here's what we're gonna do: We're gonna grease ourselves up 
 *  real good and trash that place with a baseball bat. - Homer
 */

/*
  GreasyThug - Annotations
  Everything from here on down 
  Copyright (c) 2009, STRd6 (http://strd6.com)  
  Liscensed under the MIT License 
*/

// Inject jQuery into page... gross hack... for now...
(function() {
  var head = document.getElementsByTagName('head')[0];
  
  var script = document.createElement('script');
  script.type = 'text/javascript';
  
  var jQuery = GM_getResourceText('jQuery');
  var jQueryUI = GM_getResourceText('jQueryUI');
  
  script.innerHTML = jQuery + jQueryUI;
  head.appendChild(script);
  
  $ = unsafeWindow.$;
})();
    
// Load UI Styles
(function() {
    var resources = {
      'ui-bg_diagonals-thick_18_b81900_40x40.png': GM_getResourceURL('ui-bg_diagonals-thick_18_b81900_40x40.png'), 
      'ui-bg_glass_100_f6f6f6_1x400.png': GM_getResourceURL('ui-bg_glass_100_f6f6f6_1x400.png'),
      'ui-bg_diagonals-thick_20_666666_40x40.png': GM_getResourceURL('ui-bg_diagonals-thick_20_666666_40x40.png'),
      'ui-bg_glass_65_ffffff_1x400.png': GM_getResourceURL('ui-bg_glass_65_ffffff_1x400.png'),
      'ui-bg_gloss-wave_35_f6a828_500x100.png': GM_getResourceURL('ui-bg_gloss-wave_35_f6a828_500x100.png'),
      'ui-icons_222222_256x240.png': GM_getResourceURL('ui-icons_222222_256x240.png'),
      'ui-bg_flat_10_000000_40x100.png': GM_getResourceURL('ui-bg_flat_10_000000_40x100.png'),
      'ui-icons_ef8c08_256x240.png': GM_getResourceURL('ui-icons_ef8c08_256x240.png'),
      'ui-icons_ffd27a_256x240.png': GM_getResourceURL('ui-icons_ffd27a_256x240.png'),
      'ui-bg_glass_100_fdf5ce_1x400.png': GM_getResourceURL('ui-bg_glass_100_fdf5ce_1x400.png'),
      'ui-icons_228ef1_256x240.png': GM_getResourceURL('ui-icons_228ef1_256x240.png'),
      'ui-icons_ffffff_256x240.png': GM_getResourceURL('ui-icons_ffffff_256x240.png'),
      'ui-bg_highlight-soft_75_ffe45c_1x100.png': GM_getResourceURL('ui-bg_highlight-soft_75_ffe45c_1x100.png'),
      'ui-bg_highlight-soft_100_eeeeee_1x100.png': GM_getResourceURL('ui-bg_highlight-soft_100_eeeeee_1x100.png')
    };
    
    var head = document.getElementsByTagName('head')[0];

    var style = document.createElement('style');
    style.type = 'text/css';
    
    var css = GM_getResourceText ('jQueryUICSS');
    $.each(resources, function(resourceName, resourceUrl) {
      console.log(resourceName + ': ' + resourceUrl);
      css = css.replace( 'images/' + resourceName, resourceUrl);
    });
    
    style.innerHTML = css;
    head.appendChild(style);
})();

/**
  Speakeasy abstracts the GM_xmlhttprequest and handles communication with the remote script server.
 */
var Speakeasy = function() {
  var baseUrl = 'http://67.207.139.110:9000/';
  
  function generateArrayDataTransfer(objectType, callback) {
    return function(responseData) {
      var dataArray = eval('(' + responseData + ')');
      var elements = $.map(dataArray, function(element) {
        return element[objectType];
      });
      callback(elements);
    };
  }
  
  function makeRequest(resource, options) {
    var method = options.method || 'GET';
    var url = baseUrl + resource + '.js';
    var headers = {
      'User-agent': 'Mozilla/4.0 (compatible) Greasemonkey',
      'Accept': 'application/json,application/atom+xml,application/xml,text/xml'
    };
    var data = $.param(options.data || '');
    var onSuccess = options.onSuccess || (function(){});
    
    if(method == 'POST') {
      headers['Content-type'] = 'application/x-www-form-urlencoded';
    } else if(method == 'GET') {
      if(data) {
        url += '?' + data;
      }
    }
    
    GM_xmlhttpRequest({
      method: method,
      url: url,
      headers: headers,
      data: data,
      
      onload: function(responseDetails) {
        if(responseDetails.status == 200) {
          onSuccess(responseDetails.responseText);
        } else {
          console.warn(url + ' - ' + responseDetails.status + ':\n\n' + responseDetails.responseText);
        }
      }
    });
  }
  
  function allAnnotations(url, callback) {
    var dataTransfer = generateArrayDataTransfer('annotation', callback);
    
    makeRequest('annotations', {data: {url: url}, onSuccess: dataTransfer});
  }
  
  function allScripts(callback) {
    var dataTransfer = generateArrayDataTransfer('script', callback);
    
    makeRequest('scripts', {onSuccess: dataTransfer});
  }
  
  function script(id, callback) {
    var dataTransfer = function(responseData) {
      var script = eval('(' + responseData + ')').script;
      callback(script);
    }
    makeRequest('scripts/' + id, {onSuccess: dataTransfer});
  }
  
  function createAnnotation(annotation) {
    makeRequest('annotations', {
      method: 'POST',
      data: {
        'annotation[url]': annotation.url,
        'annotation[top]': annotation.top,
        'annotation[left]': annotation.left,
        'annotation[text]': annotation.text
      }
    });
  }
  
  function updateAnnotation(annotation) {
    var id = annotation.id;
    makeRequest('annotations/update/' + id, {
      method: 'POST',
      data: {
        'annotation[top]': annotation.top,
        'annotation[left]': annotation.left
      }
    });
  }
  
  function create(code) {
    makeRequest('scripts', {
      method: 'POST', 
      data: { 
        'script[code]': code
      }
    });
  }

  var self = {
    allAnnotations: allAnnotations,
    createAnnotation: createAnnotation,
    updateAnnotation: updateAnnotation,
    allScripts: allScripts,
    script: script,
    executeScript: function(id){
      self.script(id, function(script) {
        eval(script.code);
      });
    },
    create: create
  };
  
  return self;
}();

/** Allows existing proctected methods to be called from the page console */
Function.prototype.safeCall = function() {
  var self = this, args = [];
  for (var i = 0; i < arguments.length; i++) {
    args.push(arguments[i]);
  }
  setTimeout(function() {
    alert(self);
    return self.apply(null, args);
  }, 0);
}

var Annotations = function() {  
  var self = {
    display: function (annotation) {
      var id = annotation.id;
      $('<div></div>')
        .text(annotation.text)
        .dialog({
          title: 'Annotation',
//          shadow: false,
//          draggable: false,
          buttons: { "Ok": function() { $(this).dialog("close"); } },
          position: [annotation.left, annotation.top]
        })
        .css({
          'font-size': '0.5em'
        });
    },
    
    createForm: function (x, y) {
      var input = $("<input type='text'></input>");

      var element = $('<form action="#" method="get"></form>')
        .append(input)
        .css({
          'background-color': 'yellow',
          'position': 'absolute',
          'top': y,
          'left': x,
          'z-index': 999
        })
        .submit( function() {
          var text = input.val();
          var annotation = {top: y, left: x, text: text, url: currentUrl};
          Speakeasy.createAnnotation(annotation);
          self.display(annotation);
          
          element.remove();
          return false;
        });
        
      $('body').append(element);
    }
    
  };
  
  return self;
}();


function allAnnotations(callback) {
  Speakeasy.allAnnotations(currentUrl, callback);
}

try {
  // Attach all annotations for this page from remote server
  var href = window.location.href;
  currentUrl = href.substring(href.indexOf('://') + 3);
  console.log(currentUrl);
  
  allAnnotations(function(annotations) {
    console.log(annotations);
    $.each(annotations, function(index, annotation) {
      console.log(annotation.text);
      try {
        Annotations.display(annotation);
      } catch (e) {
        console.error(e);
      }
    });
  });
  
  // Add annotation creation shizzy
  $('body').click(function(e) {
    if(e.ctrlKey) {
      Annotations.createForm(e.pageX, e.pageY);
      return false;
    }
  });
} catch(e) {
  console.error(e);
}
