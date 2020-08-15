var infoString;
var callbacks = 0;
var startButton;
var stopButton;
var startStopState = false;

let soundPoints = [];

// for enabling GPS accuracy
var options = {
  enableHighAccuracy: true,
  timeout: 10000,
  maximumAge: 2000
};

let googleMap, gpsMapMarker;

let watchId; // stores the id for the geolocation watch function

let errorMessage = "";

function preload(){
  /* SOUND POSITIONS */
  soundPoints[0] = soundPoint = {
    sound: loadSound('stina1_converted.mp3'),
    distance: 0,
    vol: 1,
    areaSize: 50.0,
    latitude: 55.659460, 
    longitude: 12.593251,
    mapMarker: ""
  }
  soundPoints[1] = soundPoint = {
    sound: loadSound('stina2_converted.mp3'),
    distance: 0,
    vol: 1,
    areaSize: 50.0,
    latitude: 55.659633, 
    longitude: 12.594239,
    mapMarker: ""
  }
  /*
  soundPoints[2] = soundPoint = {
    sound: loadSound('sound3.mp3'),
    distance: 0,
    vol: 1,
    areaSize: 50.0,
    latitude: 55.659910, 
    longitude: 12.593410,
    mapMarker: ""
  }
  */
}

function setup() {

  info = createElement('p', '');
  info.style('font-size', '16px');
  startButton = createButton("start");
  startButton.mousePressed(startApp);
  startButton.style('width:100px;height:50px');
  stopButton = createButton("stop");
  stopButton.mousePressed(stopApp);
  stopButton.attribute('disabled', '');
  stopButton.style('width:100px;height:50px');
  createP('<br>');
  createP('<br><br>');
}

function draw() {
  // put drawing code here
}

function positionChanged(position){
  callbacks++;
  errorMessage = "";

  var pos = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };
  gpsMapMarker.setPosition(pos);

  for (let i = 0; i < soundPoints.length; i++){
    let sp = soundPoints[i];
    print(sp.latitude);
    print(sp.longitude);
    print(position.coords.latitude);
    print(position.coords.longitude);

    sp.distance = float(getDistanceFromLatLon(sp.latitude, sp.longitude, position.coords.latitude, position.coords.longitude)); //
    print("dist " + sp.distance);
    print("area size " + sp.areaSize);
    sp.vol = constrain(sp.distance, 0, sp.areaSize);
    print("vol " + sp.vol);
    sp.vol = map(sp.vol, 0, sp.areaSize, 1, 0);
    print("vol mapped " + sp.vol);
    sp.sound.setVolume(sp.vol, 1);
  }

  infoString = "";
  infoString +=
    'lat: ' + position.coords.latitude + 
      '<br>lon: ' + position.coords.longitude + 
      '<br>accuracy: ' + position.coords.accuracy + ' meter' +
      '<br>pos updates: ' + callbacks +
      '<br>Error: ' + errorMessage;

  for (let i = 0; i < soundPoints.length; i++){
    let sp = soundPoints[i];
    infoString += 
      "<br><br>index: " + i +
      "<br>dist: " + sp.distance +
      "<br>vol: " + sp.vol +
      "<br>";
  }
  info.html(infoString);
}

function startApp(){
  startStopStart = true;
  stopButton.removeAttribute('disabled');
  startButton.attribute('disabled', '');

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(setupMap, error, options);
  }

  for (let i = 0; i < soundPoints.length; i++){
    soundPoints[i].sound.loop();
    soundPoints[i].sound.setVolume(soundPoints[i].vol);

    soundPoints[i].mapMarker = new google.maps.Marker({
          position: {
          lat: soundPoints[i].latitude,
          lng: soundPoints[i].longitude
        },
          map: googleMap,
          title: 'Static point'
        });
  }
  print("startApp");
}

function stopApp(){
  startButton.removeAttribute('disabled');
  stopButton.attribute('disabled', '');
  navigator.geolocation.clearWatch(watchId);
  for (let i = 0; i < soundPoints.length; i++){
    soundPoints[i].sound.stop();
  }
  print("stopApp");
}

function changeVolume(){
  for (let i = 0; i < soundPoints.length; i++){
    let sp = soundPoints[i];
    sp.vol = constrain(sp.distance, 0, sp.areaSize);
    sp.vol = map(sp.vol, 0, sp.areaSize, 1, 0);
    sp.sound.setVolume(sp.vol, 2);
  }
}


/*
function getPosition(){
  //print("test");
  //getCurrentPosition(positionChanged);
  // ask for the location callback, with the getPosition callback function triggered
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(positionChanged, error, options);
  } 
}
*/

function initMap(){
  // create map centered at the GPS position
  
  console.log("init map");
        googleMap = new google.maps.Map(document.getElementById("map"), {
          center: { lat: 55.657343, lng: 12.538782 },
          zoom: 15
        });
        gpsMapMarker = new google.maps.Marker({
          position: map.center,
          map: googleMap,
          title: 'GPS point'
        });
  console.log("init map done");
  

}

function setupMap(position){
  console.log("setupMap");

  var pos = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };

  googleMap.setCenter(pos);


  console.log("setupMap almost done");
  if (navigator.geolocation) {
    watchId = navigator.geolocation.watchPosition(positionChanged, error, options);
  }
  console.log("setupMap done");

}

function error(err) {
  console.warn(`ERROR(${err.code}): ${err.message}`);
  errorMessage += ' ' + err.code + ' ' + err.message;
}

// helper function for cutting decimals
function cutDecimals(data, nDecimals){
  var stringSplit = split(data, ".");
  return stringSplit[0]+"."+stringSplit[1].substring(0, nDecimals);
}

// helper function calculating distance between two lat/lng points
function getDistanceFromLatLon(lat1,lon1,lat2,lon2) {

  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2-lat1);  // deg2rad function below
  var dLon = deg2rad(lon2-lon1);
  
  var a = 
    Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * 
    Math.sin(dLon/2) * Math.sin(dLon/2)
    ;
  
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
  var d = R * c; // Distance in km

  return d*1000; // return the meter version of the distance
}

function deg2rad(deg) {
  return deg * (Math.PI/180);
}
