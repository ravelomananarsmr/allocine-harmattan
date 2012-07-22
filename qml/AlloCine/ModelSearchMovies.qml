import QtQuick 1.1
import com.nokia.meego 1.1

XmlListModel {

    onMovieQueryChanged: {
        //console.log("Calling API to update movieslistFile: " + "http://api.allocine.fr/rest/v3/search?partner="+partner+"&count=50&filter=movie&page=1&format=xml&q=" + movieQuery)
        var movieslistFile = new XMLHttpRequest();
        movieslistFile.onreadystatechange = function() {
            if (movieslistFile.readyState == XMLHttpRequest.DONE) {
                xml = movieslistFile.responseText
            }
        }
        movieslistFile.open("GET", "http://api.allocine.fr/rest/v3/search?partner="+partner+"&count=50&filter=movie&page=1&format=xml&q=" + movieQuery);
        movieslistFile.send();
    }

    property string movieQuery

    query: "/feed/movie"
    namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"

    XmlRole { name: "originalTitle"; query: "originalTitle/string()" }
    XmlRole { name: "title"; query: "title/string()" }
    XmlRole { name: "productionYear"; query: "productionYear/string()" }
    XmlRole { name: "releaseDate"; query: "release/releaseDate/string()" }
    XmlRole { name: "poster"; query: "poster/@href/string()" }
    XmlRole { name: "directors"; query: "castingShort/directors/string()" }
    XmlRole { name: "actors"; query: "castingShort/actors/string()" }
    XmlRole { name: "code"; query: "@code/string()" }

}
