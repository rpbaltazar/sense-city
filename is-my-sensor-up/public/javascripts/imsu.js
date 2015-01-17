var IMSU = {};

IMSU.listeners = function(){
  $("#uuid").keyup(function(evt){
    if(evt.currentTarget.value.length > 0 && $("#imsu-checker").is(":disabled") ){
      $("#imsu-checker").removeAttr('disabled');
    }
    if(evt.currentTarget.value.length == 0 && $("#imsu-checker").is(":enabled") ){
      $("#imsu-checker").attr('disabled','');
    }
  });
}

IMSU.listeners()
