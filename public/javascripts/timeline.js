var Timeline = (function() {
  var events, minTime, maxTime;

  var extractEvents = function() {
    events = [];
    minTime = maxTime = undefined;

    $('.timeline .event')
      .hide()
      .each(function() {
        var timeElement = $(this).find('time'),
            matches = /^(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})(\d{2})([+-]\d{4})$/.exec(timeElement.attr('datetime')),
            date = new Date(matches[1], parseInt(matches[2],10) - 1, matches[3], matches[4], matches[5], matches[6], 0),
            timestamp = date.getTime();

        events.push({
          timestamp: timestamp,
          date: date,
          element: $(this)
        });

        if(typeof minTime === 'undefined' || timestamp < minTime) { minTime = timestamp; }
        if(typeof maxTime === 'undefined' || timestamp > maxTime) { maxTime = timestamp; }
      })
      .first().show();;
  };

  var generateGUI = function() {
    var wrapper = $('<div/>').addClass('timeline-controls'),
        slider = $('<div/>').addClass('slider');
    wrapper.append(slider);

    $('body').append(wrapper);
    $('.timeline-controls .slider').slider({
      min: minTime,
      max: maxTime,
      slide: function(event, ui) {
        var ts = ui.value,
            found = false,
            i;

        for(i = 0; i < events.length; i++) {
          if(events[i].timestamp >= ts) {
            $('.timeline .event').hide();
            events[i].element.show();
            return true;
          }
        }
      }
    });
  };

  var tl = {

    init: function() {
      extractEvents();
      generateGUI();
      return this;
    },

    each: function(callback) {
      var i;
      for(i = 0; i < events.length; i++) {
        callback.apply(events[i]);
      }
    }

  };

  return tl;
}());

$(function() {
  Timeline.init();
});
