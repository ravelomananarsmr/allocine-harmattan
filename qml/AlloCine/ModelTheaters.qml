import QtQuick 1.1
import com.nokia.meego 1.1


XmlListModel {

    property string searchQuery
    property int radius: 10

    function performTheatersQuery(){
        if (searchQuery){
            console.log("Calling API to update modelTheaters: " + "http://api.allocine.fr/rest/v3/theaterlist?partner="+partner+"&count=200&page=1&"+searchQuery+"&format=xml&radius=" + radius)
            var theaterslistFile = new XMLHttpRequest();
            theaterslistFile.onreadystatechange = function() {
                if (theaterslistFile.readyState == XMLHttpRequest.DONE) {
                    //console.log("answer received: " + theaterslistFile.responseText)
                    xml = theaterslistFile.responseText
                }
            }
            theaterslistFile.open("GET", "http://api.allocine.fr/rest/v3/theaterlist?partner="+partner+"&count=200&page=1&"+searchQuery+"&format=xml&radius=" + radius);
            theaterslistFile.send();
        }
    }

    query: "/feed/theater"
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

    onSearchQueryChanged: performTheatersQuery()
    onRadiusChanged: performTheatersQuery()
    //onCountChanged: console.log("First element: " + get(0).name)
}
