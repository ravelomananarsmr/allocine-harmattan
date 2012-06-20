import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.location 1.2

PageStackWindow {
    id: rootWindow
    property int pageMargin: 16
    property string partner: "YW5kcm9pZC12M3M"
    property string mobileVideoUrl: "http://m.allocine.fr/movie/viewvideo?codevideo="

    property string colorSelectedListItem: "#202020"

    property int fontSizeLarge: 25
    property int fontSizeMedium: 20
    property int fontSizeSmall: 15


    showStatusBar: rootWindow.inPortrait

    Component.onCompleted: theme.inverted = true

    platformStyle: PageStackWindowStyle {
        //background: 'Images/background.png'
        background: 'image://theme/meegotouch-video-background'
        backgroundFillMode: Image.Stretch
    }

    // ListPage is shown when the application starts, it links to
    // the component specific pages
    initialPage: PageMain { }

    // These tools are shared by most sub-pages by assigning the
    // id to a tools property of a page
    ToolBarLayout {
        id: commonTools
        visible: false
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: { myMenu.close(); pageStack.pop(); }
        }
        ToolIcon {
            iconId: "toolbar-view-menu";
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    //currentMoviesModel
    XmlListModel {
        id: currentMoviesModel
        source: "http://api.allocine.fr/rest/v3/movielist?partner="+partner+"&count=100&filter=nowshowing&page=1&order=theatercount&format=xml&profile=small"
        query: "/feed/movie"
        namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"

        XmlRole { name: "movieType"; query: "movieType/string()" }
        XmlRole { name: "originalTitle"; query: "originalTitle/string()" }
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "productionYear"; query: "productionYear/string()" }
        XmlRole { name: "releaseDate"; query: "release/releaseDate/string()" }
        XmlRole { name: "runtime"; query: "runtime/number()" }
        XmlRole { name: "synopsisShort"; query: "synopsisShort/string()" }
        XmlRole { name: "synopsis"; query: "synopsis/string()" }
        XmlRole { name: "poster"; query: "poster/@href/string()" }
        XmlRole { name: "directors"; query: "castingShort/directors/string()" }
        XmlRole { name: "actors"; query: "castingShort/actors/string()" }
        XmlRole { name: "code"; query: "@code/string()" }
    }

    //searchMoviesModel
    XmlListModel {
        id: searchMoviesModel

        property string movieQuery

        source: "http://api.allocine.fr/rest/v3/search?partner="+partner+"&count=50&filter=movie&page=1&format=xml&q=" + movieQuery
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

    //castingModel
    Component{
        id: castingModel
        XmlListModel {
            property string mCode

            source: "http://api.allocine.fr/rest/v3/movie?partner="+partner+"&q=61282&format=xml&code="+mCode
            query: "/movie/casting/castMember"
            namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"

            XmlRole { name: "personCode"; query: 'person/@code/string()' }
            XmlRole { name: "name"; query: 'person/name/string()' }
            XmlRole { name: "activity"; query: 'activity/string()' }
            XmlRole { name: "picture"; query: 'picture/@href/string()' }
            XmlRole { name: "role"; query: 'role/string()' }

       }
    }

    //screeningDateModel
    Component{
        id: screeningDateModel
        XmlListModel {
            property string theaterCode
            property string movieCode

            query: "//feed/theaterShowtimes[place/theater/@code/string()=\""+theaterCode+"\"]/movieShowtimesList/movieShowtimes[onShow/movie/@code/string()='"+movieCode+"']/screenings/scr"
            namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"
            XmlRole { name: "date"; query: '@d/string()' }
        }
    }

    //screeningTimeModel
    Component{
        id: screeningTimeModel
        XmlListModel {
            property string theaterCode
            property string movieCode
            property string screeningDate

            query: "//feed/theaterShowtimes[place/theater/@code/string()=\""+theaterCode+"\"]/movieShowtimesList/movieShowtimes[onShow/movie/@code/string()='"+movieCode+"']/screenings/scr[@d=\""+screeningDate+"\"]/t"
            namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"
            XmlRole { name: "time"; query: 'string()' }
        }
    }

    PositionSource{
        id: myPosition
        updateInterval: 30000
        active: false
        //position.coordinate.latitude: 43.58
        //position.coordinate.longitude: 1.5
        onPositionChanged: {myPosition.stop(); console.log("Position updated: " + position.coordinate.latitude + " - " + position.coordinate.longitude)}
    }
}
