import QtQuick 1.1
import com.nokia.meego 1.1


XmlListModel {

    property string personCode

    source: "http://api.allocine.fr/rest/v3/filmography?partner="+partner+"&profile=medium&format=xml&code="+personCode
    query: "/person/filmography/participation"
    namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"

    XmlRole { name: "activity"; query: "activity/string()" }
    XmlRole { name: "role"; query: "role/string()" }
    XmlRole { name: "movieTitle"; query: "movie/title/string()" }
    XmlRole { name: "movieCode"; query: "movie/@code/string()" }
    XmlRole { name: "movieOriginalTitle"; query: "movie/originalTitle/string()" }
    XmlRole { name: "movieProductionYear"; query: "movie/productionYear/string()" }
    XmlRole { name: "movieReleaseDate"; query: "movie/release/releaseDate/string()" }
    XmlRole { name: "movieReleaseState"; query: "movie/release/releaseState/string()" }
    XmlRole { name: "movieReleaseStateCode"; query: "movie/release/releaseState/@code/string()" }
    XmlRole { name: "movieCastMember"; query: "movie/casting/castMember/person/name/string()" }
    XmlRole { name: "movieCastActivity"; query: "movie/casting/castMember/activity/string()" }
    XmlRole { name: "moviePoster"; query: "movie/poster/@href/string()" }
    XmlRole { name: "code"; query: "@code/string()" }

    Component.onCompleted: console.log(source)
}
