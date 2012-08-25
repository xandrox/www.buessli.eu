function initialize() {
    $(".map").each(function(){
	console.log(this);
	var map = new google.maps.Map(this, {
	    mapTypeId: google.maps.MapTypeId.TERRAIN
	});

	var gpx = $(this).attr("gpx");

	$.ajax({
	    type: "GET",
	    url: gpx,
	    dataType: "xml",
	    success: function(xml) {
		var points = [];
		var bounds = new google.maps.LatLngBounds ();
		$(xml).find("trkpt").each(function() {
		    var lat = $(this).attr("lat");
		    var lon = $(this).attr("lon");
		    var p = new google.maps.LatLng(lat, lon);
		    points.push(p);
		    bounds.extend(p);
		});
		
		var poly = new google.maps.Polyline({
		    // use your own style here
		    path: points,
		    strokeColor: "#DCA826",
		    strokeOpacity: .7,
		    strokeWeight: 4
		});
		
		poly.setMap(map);
		
		map.fitBounds(bounds);
	    }
	});
    });
}

$(document).ready(function(){
    initialize();
});