// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require jquery-ui.min.js
//= require moment.min.js
//= require datetimepicker.min.js
//= require_tree .

$(function(){ $(document).foundation(); });

$(function() {
  $.datetimepicker.setLocale('en');
  $.datetimepicker.setDateFormatter({
    parseDate: function (date, format) {
        var d = moment(date, format);
        return d.isValid() ? d.toDate() : false;
    },

    formatDate: function (date, format) {
        return moment(date).format(format);
    }
  });

  var reformatDate = function(currentTime, $input){
    dateFromInput = $("#block-date-picker").val();
    timeFromInput = $input.val();
    currentTime = moment(dateFromInput + " " + timeFromInput).format('YYYY-MM-DD HH:mm:ss')

    if($input.attr('id') == 'start_time_visual'){
      $('#block_start_time').val(currentTime);
    } else {
      $('#block_end_time').val(currentTime);
    }
  };

  $('#block-date-picker').datetimepicker({
    format: 'M/D/YYYY',
    startDate: Date.now(),
    timepicker:false
  })

  $('.date-time-picker').datetimepicker({
    format: 'h:mm a',
    formatTime: 'h:mm a',
    formatDate: 'M/D/YYYY',
    startDate: Date.now(),
    onClose: reformatDate,
    datepicker: false
  });
});

var updateSlot = function(person_id, new_slot_id, old_slot_id){
  return $.ajax({
    method: 'POST',
    url: '/api/scheduled_spots',
    data: {
      slot: {
        new_slot_id: new_slot_id,
        old_slot_id: old_slot_id,
        person_id: person_id
      }
    }
  });
};

$(function(){
  $( ".slot" ).droppable({
    accept: ".person",
    drop: handleDropEvent
  });

  $( ".person" ).draggable({
    containment: ".blocks",
    cursor: "move",
    revert: true
  });

  function handleDropEvent( event, ui ) {
    var droppable = $(this);
    var new_slot_id = $(this).data('id')
    var draggable = ui.draggable;
    var person_id = draggable.data("id");
    var old_slot_id = draggable.data("current-slot-id")
    draggable.draggable( 'option', 'revert', false);

    updateSlot(person_id, new_slot_id, old_slot_id)
      .success(function(data){
        draggable.position( { of: droppable, my: 'left top', at: 'left top' } );
      });
  }
});
