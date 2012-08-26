function initialize() {
    $("div.map").each(function(){
	var table = $('<table class="map"></table>');
	$(this).before(table);
	$(this).detach();
	var tr = $("<tr></tr>");
	table.append(tr);
	var td = $("<td></td>");
	tr.append(td);
	td.append(this);
	var gpx = $(this).attr("gpx");
	if (window.google === undefined) {
	    return;
	}
	var map = new google.maps.Map(this, {
	    mapTypeId: google.maps.MapTypeId.TERRAIN
	});

	$.ajax({
	    type: "GET",
	    url: gpx,
	    dataType: "xml",
	    success: function(xml) {
		var points = [];
		var markers = [];
		var bounds = new google.maps.LatLngBounds ();
		$(xml).find("trk").each(function() {
                    var first = true;
		    var name = $(this).find("name").text().replace("\.small", "").replace("_R", "");
		    $(this).find("trkpt").each(function() {
			var lat = $(this).attr("lat");
			var lon = $(this).attr("lon");
			var p = new google.maps.LatLng(lat, lon);
			points.push(p);
			bounds.extend(p);

			var base = $("body").attr("base");
			var image = base + "/images/bus.png"
			if (first) {
			    var marker = new google.maps.Marker({
				map: map,
				position: p,
				title: name,
				icon: image
			    });
			    markers.push(marker);
			}
			first = false;
		    });
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

var ajustHeight = function() {
    var height = $(".left").height() + 235;
    $(".right").height(height);
}

$(document).ready(function(){
    initialize();
});