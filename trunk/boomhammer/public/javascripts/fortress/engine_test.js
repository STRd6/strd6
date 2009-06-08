/*global document, jQuery, ok, equals, test */

(function($) {
  $(function() {
    var TestObject = function(){
      var timesUpdated = 0;

      return $.extend(GameObject(), {
        update: function() {
          timesUpdated++;
        },

        timesUpdated: function() {
          return timesUpdated;
        }
      });
    };

    var RemoveOnUpdateObject = function() {
      var timesUpdated = 0;
      var $self;

      var self = $.extend(GameObject(), {
        update: function() {
          timesUpdated++;
          $self.trigger("remove");
        },

        timesUpdated: function() {
          return timesUpdated;
        }
      });

      $self = $(self);

      return self;
    };

    test("Update one object once", function(){
      var engine = Engine();

      var gameObject = TestObject();

      engine.add(gameObject, {updatable: true});
      engine.update();

      equals(gameObject.timesUpdated(), 1);
    });

    test("Update many objects once", function(){
      var engine = Engine();

      var gameObjects = [
        TestObject(),
        TestObject(),
        TestObject(),
        TestObject()
      ];

      $.each(gameObjects, function(index, object) {
        engine.add(object, {updatable: true});
      });

      engine.update();

      $.each(gameObjects, function(index, object) {
        equals(object.timesUpdated(), 1);
      });
    });

    test("Update many objects many times", function(){
      var engine = Engine();
      var many = 50;

      var gameObjects = [
        TestObject(),
        TestObject(),
        TestObject(),
        TestObject()
      ];

      $.each(gameObjects, function(index, object) {
        engine.add(object, {updatable: true});
      });

      many.times(function() {
        engine.update();
      });

      $.each(gameObjects, function(index, object) {
        equals(object.timesUpdated(), many);
      });
    });

    test("Update many objects correctly when removing one", function() {
      var engine = Engine();

      var removeObject = RemoveOnUpdateObject();

      var gameObjects = [
        TestObject(),
        TestObject(),
        TestObject()
      ];

      engine.add(removeObject, {updatable: true});

      $.each(gameObjects, function(index, object) {
        engine.add(object, {updatable: true});
      });

      engine.update();
      engine.update();

      equals(removeObject.timesUpdated(), 1);

      $.each(gameObjects, function(index, object) {
        equals(object.timesUpdated(), 2);
      });
    });

    test("object added trigger", function() {
      var engine = Engine();
      var gameObject = TestObject();
      var eventOptions = {some: 'value'};

      expect(2);

      $(engine).bind("objectAdded", function(e, object, options) {
        equals(object, gameObject);
        equals(options, eventOptions);
      });

      engine.add(gameObject, {eventOptions: eventOptions});
    });

    test("object removed trigger", function() {
      var engine = Engine();
      var gameObject = RemoveOnUpdateObject();

      expect(1);

      $(engine).bind("objectRemoved", function(e, object) {
        equals(object, gameObject);
      });

      engine.add(gameObject, {updatable: true});
      engine.update();
    });
  });
})(jQuery);