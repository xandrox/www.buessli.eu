var header = {};
var panoramas = {};
var alben = {};

$(document).ready(function() {
    header.pictures = [];
    panoramas.pictures = [];
    $("table[data-title]").each(function() {
	var table = $(this);
	var title = table.attr("data-title");
	$.ajax({
	    url : "/site/rest/open/picasa/pictures.json?name=" + title,
	    success : function(album) {
		table.data("album", album);
		setTimeout(function() {
		    switchPictures(table);
		}, getRandomTime());
	    }
	});
    });
    $("#panoramas").each(function() {
	$.ajax({
	    url : "/site/rest/open/picasa/panoramas.json?size=15",
	    success : function(result) {
		panoramas = result;
		showPanoramas(10);
	    }
	});
    });
});

var headerPictureCounter = 0;

var log = function(message) {
    // console.log(message);
}

var switchPictures = function(table) {
    var pictures = $(table).data("album");
    var title = $(table).attr("data-title");
    if ($(table).next().find("a[data-title='" + title + "']").length == 0) {
	var a = $("<center><a data-title='" + title + "' href=\""
		    + pictures.picasaAlbum
		  + "\">[alle Bilder anzeigen]</a></center><br/><br/>");
	$(table).after(a);
    }
    
    var images = $(table).find("img");
    var tds = $(table).find("td");
    
    if (pictures.pictures.length > images.length) {
	var nextPictureReplacement = $(table).data("nextPictureReplacement");
	if (nextPictureReplacement === undefined) {
	    nextPictureReplacement = 0;
	} else {
	    nextPictureReplacement = (++nextPictureReplacement) % images.length;
	}
	log("nextPictureReplacement " + nextPictureReplacement);
	$(table).data("nextPictureReplacement", nextPictureReplacement);
	
	var nextPicture = $(table).data("nextPicture");
	if (nextPicture === undefined) {
	    var dataOffset = $(table).attr("data-offset");
	    if (dataOffset === undefined) {
		dataOffset = images.length + 1;
	    } else {
		dataOffset = dataOffset % pictures.pictures.length; 
	    }
	    nextPicture = dataOffset;
	} else {
	    nextPicture = (++nextPicture) % pictures.pictures.length;
	}
	log("nextPicture " + nextPicture);
	$(table).data("nextPicture", nextPicture);
	
	var td = tds[nextPictureReplacement];
	var img = $(td).find("img");
	
	var url = "/site/rest/open/picasa/" + pictures.album + "/"
	    + (nextPicture + 1) + ".jpg.base64";
	
	var link = "";
	if (pictures.pictures.length > nextPicture) {
	    link = pictures.pictures[nextPicture].picasaAlbum;
	}
	
	log(td);
	log(img);
	log(url);
	
	$.ajax({
	    url : url,
	    success : function(base64) {
		var newImg = $("<img src=\"data:image/jpg;base64," + base64
			       + "\">");
		$(img).css("z-index", "1000");
		img.after(newImg);
		$(img).fadeOut(2000, function() {
		    $(img).remove();
		    $(td).find("a").attr("href", link);
		    setTimeout(function() {
			switchPictures(table);
		    }, getRandomTime());
		});
	    }
	});
    }
}

var switchHeaders = function() {
    log("switchHeaders " + headerPictureCounter);
    headerPictureCounter = (++headerPictureCounter) % header.pictures.length;
    var picture = header.pictures[headerPictureCounter];
    var url = "/site/rest/open/picasa/" + picture.cache + ".base64";
    log(url);
    var headerDiv = $("#header");
    var actualHeaderImage = headerDiv.find("img");
    $.ajax({
	url : url,
	success : function(base64) {
	    var newHeaderImage = $("<img id=\"logo_image\" src=\"data:image/jpg;base64," + base64
				   + "\" />");
	    actualHeaderImage.css("z-index", "1000");
	    actualHeaderImage.after(newHeaderImage);
	    actualHeaderImage.fadeOut(2000, function() {
		actualHeaderImage.remove();
		setTimeout(function() {
		    switchHeaders();
		}, getRandomTime());
	    });
	}
    });
    return;
    
    $("#logo_image").fadeOut('slow', function() {
	$("#logo_image").css("background-image", "url('" + src + "')");
	$("#logo_image").fadeIn('slow', function() {
	    setTimeout(function() {
		switchHeaders();
	    }, getRandomTime() * 5);
	});
    });
}

var showPanoramas = function() {
    $("#panoramas").html("");
    for ( var counter = 0; counter < panoramas.pictures.length; counter++) {
	var picture = panoramas.pictures[counter];
	var td = $("<tr><td><a href=\"" + picture.picasaAlbum
		   + "\"><img src=\"" + picture.picasaImage
		   + "\" /></a></td></tr>");
	$("#panoramas").append(td);
    }
    var a = $("<center><a data-title='panorama' href=\""
	      + panoramas.picasaAlbum
	      + "\">[alle Bilder anzeigen]</a></center><br/><br/>");
    $("#panoramas").after(a);
}

function getRandomTime() {
    var randomTime = Math.floor(2000 * Math.random());
    randomTime += 4000;
    return randomTime;
}
