// ==UserScript==
// @name           GreasyThug - Annotations
// @namespace      http://strd6.com
// @description    Super-simple website annotations shared with all!
// @include        *
// @require        http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js
// @require        http://ajax.googleapis.com/ajax/libs/jqueryui/1.5.2/jquery-ui.min.js

// ==/UserScript==

/** -GreasyThug-
 *  
 *  I've been called a greasy thug, too. It never stops hurting. 
 *  So here's what we're gonna do: We're gonna grease ourselves up 
 *  real good and trash that place with a baseball bat. - Homer
 */

/* 
jquery.event.drag.js ~ v1.4 ~ Copyright (c) 2008, Three Dub Media (http://threedubmedia.com)  
Liscensed under the MIT License ~ http://threedubmedia.googlecode.com/files/MIT-LICENSE.txt
*/
(function(H){H.fn.drag=function(K,J,I){if(J){this.bind("dragstart",K)}if(I){this.bind("dragend",I)}return !K?this.trigger("drag"):this.bind("drag",J?J:K)};var D=H.event,B=D.special,F=B.drag={not:":input",distance:0,which:1,setup:function(I){I=H.extend({distance:F.distance,which:F.which,not:F.not},I||{});I.distance=G(I.distance);D.add(this,"mousedown",E,I)},teardown:function(){D.remove(this,"mousedown",E);if(this===F.dragging){F.dragging=F.proxy=null}C(this,true)}};function E(K){var J=this,I,L=K.data||{};if(L.elem){J=K.dragTarget=L.elem;K.dragProxy=F.proxy||J;K.cursorOffsetX=L.pageX-L.left;K.cursorOffsetY=L.pageY-L.top;K.offsetX=K.pageX-K.cursorOffsetX;K.offsetY=K.pageY-K.cursorOffsetY}else{if(F.dragging||(L.which>0&&K.which!=L.which)||H(K.target).is(L.not)){return }}switch(K.type){case"mousedown":H.extend(L,H(J).offset(),{elem:J,target:K.target,pageX:K.pageX,pageY:K.pageY});D.add(document,"mousemove mouseup",E,L);C(J,false);return false;case !F.dragging&&"mousemove":if(G(K.pageX-L.pageX)+G(K.pageY-L.pageY)<L.distance){break}K.target=L.target;I=A(K,"dragstart",J);if(I!==false){F.dragging=J;F.proxy=K.dragProxy=H(I||J)[0]}case"mousemove":if(F.dragging){I=A(K,"drag",J);if(B.drop){B.drop.allowed=(I!==false);B.drop.handler(K)}if(I!==false){break}K.type="mouseup"}case"mouseup":D.remove(document,"mousemove mouseup",E);if(F.dragging){if(B.drop){B.drop.handler(K)}A(K,"dragend",J)}C(J,true);F.dragging=F.proxy=L.elem=null;break}}function A(L,J,K){L.type=J;var I=D.handle.call(K,L);return I===false?false:I||L.result}function G(I){return Math.pow(I,2)}function C(J,I){if(!J){return }J.unselectable=I?"off":"on";J.onselectstart=function(){return I};if(document.selection&&document.selection.empty){document.selection.empty()}if(J.style){J.style.MozUserSelect=I?"":"none"}}})(jQuery);

/*
  GreasyThug - Annotations
  Everything from here on down 
  Copyright (c) 2009, STRd6 (http://strd6.com)  
  Liscensed under the MIT License 
*/

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

var Annotations = function() {  
  var self = {
    display: function (annotation) {
      var id = annotation.id;
      var element = $('<div></div>')
        .append(document.createTextNode(annotation.text))
        .css({
          'background-color': 'yellow',
          'position': 'absolute',
          'top': annotation.top,
          'left': annotation.left,
          'z-index': 999
        })
        .bind('drag', function( event ) {
          $( this ).css({
            top: event.offsetY,
            left: event.offsetX
          });
        })
        .bind('dragend', function( event ) {
          Speakeasy.updateAnnotation({id: id, top: $(this).css('top'), left: $(this).css('left')});
        });
        
      $('body').append(element);
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

$(document).ready(function() {
  if(unsafeWindow.console) {
    console = unsafeWindow.console;
  }
  
  try {
    // Attach all annotations for this page from remote server
    var href = window.location.href;
    currentUrl = href.substring(href.indexOf('://') + 3);
    Speakeasy.allAnnotations(currentUrl, function(annotations) {
      $.each(annotations, function(index, annotation) {
        Annotations.display(annotation);
      });
    });
    
    // Add annotation creation shizzy
    $('body').click(function(e) {
      if(e.shiftKey) {
        Annotations.createForm(e.pageX, e.pageY);
        return false;
      }
    });
  } catch(e) {
    console.error(e);
  }
});
