import QtQuick 1.1
import com.nokia.meego 1.0


XmlListModel {

    property string searchLat
    property string searchLong
    property string searchCode
    property string searchZip
    property string searchLocation
    property int searchRadius: 10

    property string searchQuery

    function performTheatersQuery(){
        if (searchQuery){

            console.log("Calling API to update ModelTheaters: " + "http://api.allocine.fr/rest/v3/theaterlist?partner="+partner+"&count=200&page=1&format=xml&"+searchQuery+"&radius="+searchRadius)
            var theaterslistFile = new XMLHttpRequest();
            theaterslistFile.onreadystatechange = function() {
                if (theaterslistFile.readyState == XMLHttpRequest.DONE) {
                    //console.log("answer received: " + theaterslistFile.responseText)
                    xml = theaterslistFile.responseText
                }
            }
            theaterslistFile.open("GET", "http://api.allocine.fr/rest/v3/theaterlist?partner="+partner+"&count=200&page=1&format=xml&"+searchQuery+"&radius="+searchRadius);
            theaterslistFile.send();

            if (searchCode) {
                query = "/feed/theater[@code=\""+ searchCode + "\"]"
            } else {
                query = "/feed/theater"

            }
        }
    }

    namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"

    XmlRole { name: "name"; query: "name/string()" }
    XmlRole { name: "address"; query: "address/string()" }
    XmlRole { name: "city"; query: "city/string()" }
    XmlRole { name: "postalCode"; query: "postalCode/string()" }
    XmlRole { name: "cinemaChain"; query: "cinemaChain/string()" }
    XmlRole { name: "screenCount"; query: "screenCount/string()" }
    XmlRole { name: "tlatitude"; query: "geoloc/@lat/number()" }
    XmlRole { name: "tlongitude"; query: "geoloc/@long/number()" }
    XmlRole { name: "code"; query: "@code/string()" }
    //onStatusChanged: {if (status == XmlListModel.Ready) console.log(count + " theaters found")}

    onSearchLatChanged: {
        // Build API query
        searchQuery = "lat="+searchLat+"&long="+searchLong
        performTheatersQuery()
    }
    onSearchLongChanged: {
        // Build API query
        searchQuery = "lat="+searchLat+"&long="+searchLong
        performTheatersQuery()
    }
    onSearchRadiusChanged: {
        performTheatersQuery()
    }
    onSearchCodeChanged: {
        // Build API query
        searchQuery = "theater="+searchCode
        performTheatersQuery()
    }
    onSearchLocationChanged: {
        // Build API query
        searchQuery = "location="+searchLocation
        performTheatersQuery()
    }
    onSearchZipChanged: {
        // Build API query
        searchQuery = "zip="+searchZip
        performTheatersQuery()
    }
    //onCountChanged: console.log("First element: " + get(0).name)
}
