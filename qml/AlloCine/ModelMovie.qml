import QtQuick 1.1
import com.nokia.meego 1.0


XmlListModel {
    property string mCode

    source: "http://api.allocine.fr/rest/v3/movie?partner="+partner+"&q=61282&format=xml&code="+mCode
    query: "/movie"
    namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"

    //XmlRole { name: "mCode"; query: '@code/string()' }
    XmlRole { name: "movieType"; query: 'movieType/string()' }
    XmlRole { name: "originalTitle"; query: 'originalTitle/string()' }
    XmlRole { name: "title"; query: 'title/string()' }
    XmlRole { name: "productionYear"; query: 'productionYear/string()' }

    XmlRole { name: "releaseDate"; query: "release/releaseDate/string()" }
    XmlRole { name: "distributor"; query: "release/distributor/@name/string()" }

    XmlRole { name: "runtime"; query: "runtime/number()" }
    XmlRole { name: "synopsis"; query: "synopsis/string()" }
    XmlRole { name: "synopsisShort"; query: "synopsisShort/string()" }

    XmlRole { name: "directors"; query: "castingShort/directors/string()" }
    XmlRole { name: "actors"; query: "castingShort/actors/string()" }

    XmlRole { name: "certificate"; query: "movieCertificate/certificate/string()" }

    XmlRole { name: "poster"; query: "poster/@href/string()" }
    XmlRole { name: "trailer"; query: "trailer/@href/string()" }

    XmlRole { name: "pressRating"; query: "statistics/pressRating/number()" }
    XmlRole { name: "pressReviewCount"; query: "statistics/pressReviewCount/number()" }
    XmlRole { name: "userRating"; query: "statistics/userRating/number()" }
    XmlRole { name: "userReviewCount"; query: "statistics/userReviewCount/number()" }
    XmlRole { name: "userRatingCount"; query: "statistics/userRatingCount/number()" }
    XmlRole { name: "commentCount"; query: "statistics/commentCount/number()" }
    XmlRole { name: "fanCount"; query: "statistics/fanCount/number()" }
    XmlRole { name: "theaterCount"; query: "statistics/theaterCount/number()" }
    XmlRole { name: "theaterCountOnRelease"; query: "statistics/theaterCountOnRelease/number()" }
    XmlRole { name: "releaseWeekPosition"; query: "statistics/releaseWeekPosition/number()" }
}
