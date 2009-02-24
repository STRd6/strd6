/*
  Speakeasy.js 
  Copyright (c) 2009, STRd6 (http://strd6.com)  
  Liscensed under the MIT License 
  
  Prerequisites: 
    Greasemonkey Environment
    jQuery
*/

/**
  Speakeasy abstracts the GM_xmlhttprequest and handles communication with the remote script server.
  It's kind of like ActiveResource
 */
Speakeasy = function($) {
  var baseUrl = 'http://localhost:3000/';
  var apiKey = 0;
  
  function generateArrayDataTransfer(objectType, callback) {
    return function(responseData) {
      var dataArray = eval('(' + responseData + ')');
      var elements = $.map(dataArray, function(element) {
        return element[objectType];
      });
      callback(elements);
    };
  }
  
  function generateDataTransfer(objectType, callback) {
    return function(responseData) {
      var data = eval('(' + responseData + ')');
      callback(data[objectType]);
    };
  }
  
  function loadOptionsData(type, dataObject) {
    var optionsData = {
      api_key: apiKey
    };
    
    $.each(dataObject, function(field, value) {
      log(field + ': ' + value)
      optionsData[type + '[' + field +']'] = value;
    });
    return optionsData;
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
  
  function generateResource(type) {
    var pluralType = type + 's';
    
    var all = function() {
      return function(options, callback) {
        var dataTransfer = generateArrayDataTransfer(type, callback);
        options.onSuccess = dataTransfer;
        makeRequest(pluralType, options);
      };
    }();
    
    var create = function() {
      return function(dataObject, callback) {
        var options = {
          method: 'POST'
        };
        
        options.data = loadOptionsData(type, dataObject);
        makeRequest(pluralType, options);
      };
    }();
    
    var find = function() {
      return function(options, callback) {
        var dataTransfer = generateDataTransfer(type, callback);
        if(typeof(options) == 'number') {
          options.onSuccess = dataTransfer;
          makeRequest(pluralType + '/' + options, dataTransfer);
        } else {
          log("TODO: Non-integer find not currently supported!");
        }
      };
    }();
    
    var update = function() {
      return function(dataObject, callback) {
        var id = dataObject.id;
        var options = {
          method: 'POST'
        };
        
        options.data = loadOptionsData(type, dataObject);
        makeRequest(pluralType + '/update/' + id, options);
      };
    }();
    
    var resource = {
      all: all,
      create: create,
      find: find,
      update: update
    };
    
    return resource;
  }

  var self = {
    annotation: generateResource('annotation'),
    script: generateResource('script')
  };
  
  return self;
}(jQuery);