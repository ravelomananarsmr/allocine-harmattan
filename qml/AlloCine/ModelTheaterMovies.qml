import QtQuick 1.1
import com.nokia.meego 1.1

XmlListModel {
    Component.onCompleted: {
        console.log("Calling API to update modelTheaterMovies: " + "http://api.allocine.fr/rest/v3/showtimelist?partner="+partner+"&q=61282&format=xml&theaters="+theaterCode)
        var showtimelistFile = new XMLHttpRequest();
        showtimelistFile.onreadystatechange = function() {
            if (showtimelistFile.readyState == XMLHttpRequest.DONE) {
                xml = showtimelistFile.responseText

            }
        }
        showtimelistFile.open("GET", "http://api.allocine.fr/rest/v3/showtimelist?partner="+partner+"&q=61282&format=xml&theaters="+theaterCode);
        showtimelistFile.send();
    }

    property string theaterCode
    property date showDate // Not Implemented

    //query: "//feed/theaterShowtimes[place/theater/@code/string()=\""+theaterCode+"\" and movieShowtimesList/movieShowtimes/screenings/scr/@d/string()=\""+ Qt.formatDateTime(showDate, "yyyy-MM-dd") + "\"]/movieShowtimesList/movieShowtimes"
    query: "//feed/theaterShowtimes[place/theater/@code/string()=\""+theaterCode+"\"]/movieShowtimesList/movieShowtimes"

    namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"
    XmlRole { name: "title"; query: 'onShow/movie/title/string()' }
    XmlRole { name: "mCode"; query: 'onShow/movie/@code/string()' }
    XmlRole { name: "poster"; query: "onShow/movie/poster/@href/string()" }
    XmlRole { name: "version"; query: "version/string()" }
    XmlRole { name: "screenFormat"; query: "screenFormat/string()" }
    XmlRole { name: "runtime"; query: "onShow/movie/runtime/number()" }
    XmlRole { name: "directors"; query: "onShow/movie/castingShort/directors/string()" }
    XmlRole { name: "actors"; query: "onShow/movie/castingShort/actors/string()" }
    XmlRole { name: "screenFormatCode"; query: "screenFormat/@code/string()" }
    XmlRole { name: "versionCode"; query: "version/@code/string()" }


//    onCountChanged: console.log("Count changed: " + count)
//    onXmlChanged: console.log("XML loaded from API")
//    onStatusChanged: {
//        if (status == XmlListModel.Loading){
//            console.log("Model Loading")
//        } else if (status == XmlListModel.Ready){
//            console.log("Model Ready")
//        }
//    }
//    onProgressChanged: console.log("Progress: " + progress)
}
