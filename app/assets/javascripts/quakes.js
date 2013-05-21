/* range in km of an earthquake
 * - this should ideally find epicentral distance and convert to surface distance
 * - 
 */
function range(quake) {
  m = quake.magnitude;
  // m_l = log_10 Amp + 2.76 log(D) - 2.48 for distances below 100 km
  // 10^(m_l - 2.76 log(d) + 2.48) = Amp
  // so between 10 km and 100 km the magnitude decreases by 2.5
  // so for > 3.5 earthquakes, they will be 1 equivalent to a nearby 1 mag earthquake before 100km
  // 2.76 log(D) - 2.76 log(D') = x, the decay from D to D' distance ( set this to M_L - 1 )
  // 10^(x / 2.76) * D' = D (distance to decay a given amount)
  // So D' = 10 means a magnitude 1 earthquake at 10km
  return Math.pow(10, (m-1)/2.65) * 10
  
  // m_l = log_10 Amp + 1.6 log(D) - 0.15 where D is dist in km 100 - 200km
  // log(200) - log(100) * 1.6 =~ .5 decrease in magnitude across this area
  // that is to say a 2.5 from 100 km feels like a 3.0 from 200km
  
  // m_l = log_10 Amp + 3.0 log(D) - 3.38 where D is dist in km 100 - 200km
  // log(600) - log(200) * 3.0 =~ 1.5 decrease in magnitude across this area
}

function init_map(lat, lon, no_marker) {
  var mapOptions = {
    center: new google.maps.LatLng(lat, lon),
    zoom: 6,
    scrollwheel: false,
    zoomControl: false,
    mapTypeId: google.maps.MapTypeId.TERRAIN
  };

  var quakes = $('#quakes').text().split('\n').map(function(e) { return JSON.parse(e) });
  var map = new google.maps.Map(document.getElementById("map-canvas"),
      mapOptions);

  if(!no_marker) {
    marker = new google.maps.Marker({
      position: mapOptions.center,
      map: map,
      fillColor: "blue"
    });
  }

  quakes.forEach(function(quake) {
    var circleOpts = {
      strokeColor: '#FF0000',
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: '#FF0000',
      fillOpacity: 0.35,
      map: map,
      center: new google.maps.LatLng(quake.latitude, quake.longitude),
      radius: range(quake) * 1000, // meters from km
      clickable: true
    };

    var circle = new google.maps.Circle(circleOpts);

    var infowindow = new google.maps.InfoWindow({
      content: ('<p>M<sub>L</sub> ' + quake.magnitude + '<br/>' + quake.datetime + '</p>'),
      // 'The area of the circle is a rough estmate of the area affected by the earthquake.  ' +
      // 'At the edge of the border the earthquake should feel about the same as a ' +
      // 'M<sub>L</sub> 1.0 earthquake from 10 km away (basically negligible)</p>'),
      position: circleOpts.center
    });

    google.maps.event.addListener(circle, 'click', function() {
      infowindow.open(map);
    });
  });

  google.maps.event.addListener(map, 'dragend', function() {
    new_center = map.getCenter();
    console.log(new_center.lat() + ' ' + new_center.lng());
    $.ajax({
      data: { 
        latitude: new_center.lat(),
        longitude: new_center.lng(),
        from_drag: true
      },
      dataType: 'script'
    });
  });
}
