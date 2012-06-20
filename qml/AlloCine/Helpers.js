function formatdistance(precise_distance_meters){
    var distance_meters = Math.round(precise_distance_meters);
    var res;
    if (distance_meters < 1000){
        res = distance_meters + "m";
    } else if (distance_meters < 10000) {
        res = Math.round(distance_meters/100)/10 + "km";
    } else {
        res = Math.round(distance_meters/1000) + "km";
    }
    return res;
}

function formatSecondsAsTime(secs, format) {
  var hr  = Math.floor(secs / 3600);
  var min = Math.floor((secs - (hr * 3600))/60);
  var sec = Math.floor(secs - (hr * 3600) -  (min * 60));

  if (hr < 10)   { hr    = "0" + hr; }
  if (min < 10) { min = "0" + min; }
  if (sec < 10)  { sec  = "0" + sec; }
  if (hr == 0)            { hr   = "00"; }

  if (format != null) {
    var formatted_time = format.replace('hh', hr);
    formatted_time = formatted_time.replace('h', hr*1+""); // check for single hour formatting
    formatted_time = formatted_time.replace('mm', min);
    formatted_time = formatted_time.replace('m', min*1+""); // check for single minute formatting
    formatted_time = formatted_time.replace('ss', sec);
    formatted_time = formatted_time.replace('s', sec*1+""); // check for single second formatting
    return formatted_time;
  } else {
    return hr + ':' + min + ':' + sec;
  }
}
