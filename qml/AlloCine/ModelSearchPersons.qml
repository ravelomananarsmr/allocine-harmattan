import QtQuick 1.1
import com.nokia.meego 1.1

XmlListModel {

    onPersonQueryChanged: {
        //console.log("Calling API to update movieslistFile: " + "http://api.allocine.fr/rest/v3/search?partner="+partner+"&count=50&filter=movie&page=1&format=xml&q=" + movieQuery)
        var personslistFile = new XMLHttpRequest();
        personslistFile.onreadystatechange = function() {
            if (personslistFile.readyState == XMLHttpRequest.DONE) {
                xml = personslistFile.responseText
            }
        }
        personslistFile.open("GET", "http://api.allocine.fr/rest/v3/search?partner="+partner+"&count=50&filter=person&page=1&format=xml&q=" + personQuery);
        personslistFile.send();
    }

    property string personQuery

    query: "/feed/person"
    namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"

    XmlRole { name: "name"; query: "name/string()" }
    XmlRole { name: "gender"; query: "gender/number()" }
    XmlRole { name: "birthDate"; query: "birthDate/string()" }
    XmlRole { name: "releaseDate"; query: "release/releaseDate/string()" }
    XmlRole { name: "picture"; query: "picture/@href/string()" }
    XmlRole { name: "code"; query: "@code/string()" }

}
