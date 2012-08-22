// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import QtMobility.location 1.2
import "DateTools.js" as DateTools
import "Helpers.js" as Helpers

Page {
    id: theaterPage
    tools: buttonTools

    property string theaterCode
    property date showDate

    property variant theaterLatitude: 0
    property variant theaterLongitude: 0
    property string theaterName
    property string theaterAddress
    property string theaterPostalCode
    property string theaterCity
    property string theaterCinemaChain
    property string theaterScreenCount

    ModelTheaters {
        id: modelTheater
        searchCode:  theaterCode

        onStatusChanged: {
            if (status == XmlListModel.Loading){
                //console.log("modelTheater loading")
                windowTitleBar.visible = false
                theaterMovies.visible = false
                //theaterPageLoadingOverlay.show()
                theaterPageLoadingOverlay.loadingText = "Chargement du cinéma"
            } else if (status == XmlListModel.Ready && count > 0){
                theaterName = get(0).name
                theaterAddress = get(0).address
                theaterLatitude = get(0).tlatitude
                theaterLongitude = get(0).tlongitude
                theaterPostalCode = get(0).postalCode
                theaterCity = get(0).city
                theaterCinemaChain = get(0).cinemaChain
                theaterScreenCount = get(0).screenCount
                windowTitleBar.visible = true
                modelTheaterMovies.theaterCode = theaterCode
                modelTheaterMovies.performTheaterMoviesQuery()
                //console.log("modelTheater ready, count=" + count + ", name=" + theaterName)
            }
        }
    }

    ToolBarLayout {
        id: buttonTools
        ToolIcon { iconId: "toolbar-back"; onClicked: { myPosition.stop(); myMenu.close(); pageStack.pop(); }  }
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: "Cinéma " + theaterName
    }

    Component {
        id: theaterDetails

        Row {
            anchors.bottomMargin: 16

            // map
            Map {
                id: map
                plugin : Plugin {name : "nokia"}
                size.height: theaterDetailsText.height
                size.width: theaterDetailsText.height
                zoomLevel: 15
                center: Coordinate {
                    id: theaterCoordinate
                    latitude: theaterLatitude
                    longitude: theaterLongitude
                }

                MapImage {
                    id: theaterMarker
                    //width: 50
                    //height: 50
                    offset.x: -71/2
                    offset.y: -71
                    source: "Images/pinpoint-theater.png"
                    coordinate: theaterCoordinate
                }

                MapImage {
                    id: meMarker
                    //width: 50
                    //height: 50
                    offset.x: -71/2
                    offset.y: -71
                    source: "Images/pinpoint-me.png"
                    coordinate: myPosition.position.coordinate
                }

                MouseArea {
                    id: mapMouseArea
                    anchors.fill: parent
                    onPressed: {
                        //Qt.openUrlExternally("geo:" + theaterCoordinate.latitude + "," + theaterCoordinate.longitude)
                        console.log("pageStack depth: " + pageStack.depth)
                        var component = Qt.createComponent("PageTheatersMap.qml")
                        if (component.status == Component.Ready) {
                            console.log("Opening Map centered on lat=" + theaterCoordinate.latitude + " and long = " + theaterCoordinate.longitude);
                            if (pageStack.depth > 3) {
                                pageStack.pop()
                            } else {
                                pageStack.push(component, {
                                     aroundMe: false,
                                     centerCoordinate: theaterCoordinate
                                 });
                            }
                        } else {
                            console.log("Error loading component:", component.errorString());
                         }
                    }
                }

            }

            Column {
                anchors.margins: 16
                id: theaterDetailsText

                Label {
                    id: theaterAddressLabel
                    text: theaterAddress
                    color: "ghostwhite"
                }
                Label {
                    id: cityLabel
                    text: theaterPostalCode + " " + theaterCity
                    color: "ghostwhite"
                }
                Label {
                    id: distanceLabel
                    text: (myPosition.position.coordinate.latitude || myPosition.position.coordinate.longitude) ? Helpers.formatdistance(theaterCoordinate.distanceTo(myPosition.position.coordinate)) + " de moi" : "Calcul de la distance..."
                    color: "gold"
                }

                Label {
                    text: "Type: " + theaterCinemaChain
                    color: "ghostwhite"
                }
                Label {
                    text: "Ecrans: " + theaterScreenCount
                    color: "ghostwhite"
                }
            }
        }

    }

    LoadingOverlay {
        id: theaterPageLoadingOverlay
        visible: true
        loadingText: "Chargement des séances"
    }

    ModelTheaterMovies {
        id: modelTheaterMovies
        theaterCode: theaterCode
        showDate: showDate
        onStatusChanged: {
            if (status == XmlListModel.Loading){
                //console.log("modelTheaterMovies loading")
                theaterPageLoadingOverlay.loadingText = "Chargement des séances"
            } else if (status == XmlListModel.Ready){
                //console.log("modelTheaterMovies ready")
                showDate = new Date();
                //console.log("Model Ready, today=" + Qt.formatDateTime(showDate, "yyyy-MM-dd"))
                //console.log("//feed/theaterShowtimes[place/theater/@code/string()=\""+theaterCode+"\" and movieShowtimesList/movieShowtimes/screenings/scr/@d/string()=\""+ Qt.formatDateTime(showDate, "yyyy-MM-dd") + "\"]/movieShowtimesList/movieShowtimes")
                if (theaterMovies.model.xml){ // To be sure there is somthing loaded
                    if (count > 0){
                        noShow.visible = false
                        theaterMovies.visible = true
                    } else {
                        //console.log("No movie for this theater")
                        noShow.visible = true
                        theaterMovies.visible = false
                    }
                    theaterPageLoadingOverlay.hide()
                }
            }
        }
        onCountChanged: {
            console.log(count + " movies for this theater" )
        }
    }

    ListView {
        id:theaterMovies
        anchors.top:windowTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 5
        model:modelTheaterMovies
        header: theaterDetails
        spacing: 10
        cacheBuffer: 3000

        delegate:Component{

            Column {

                width: theaterPage.width

                Component.onCompleted: {
                    //console.debug(code +" - "+ mCode)
                    screening.model=screeningDateModel.createObject(screening,{theaterCode:theaterCode,movieCode:mCode, xml:theaterMovies.model.xml, versionCode:versionCode, screenFormatCode:screenFormatCode})
                }

                ListComponentMovie {
                    movieActors: model.actors
                    movieCode: model.mCode
                    movieDirectors: model.directors
                    movieReleaseDate: model.releaseDate
                    movieTitle: model.title
                    moviePoster: model.poster
                }

                // versionRow
                Row {
                    id: versionRow
                    anchors.horizontalCenter: parent.horizontalCenter

                    //showTimesLabel
                    Label {
                        id: showTimesLabel
                        text: "Séances "
                        color: "ghostwhite"
                    }

                    Label {
                        id: versionLabel
                        text: model.version
                        font.weight: Font.Light
                        elide: Text.ElideRight
                        color: "ghostwhite"
                        visible: model.version != ""
                    }

                    Label {
                        text: " - "
                        font.weight: Font.Light
                        elide: Text.ElideRight
                        color: "ghostwhite"
                        visible: model.screenFormat != ""
                    }

                    Label {
                        id: screenFormatLabel
                        text: model.screenFormat
                        font.weight: Font.Light
                        elide: Text.ElideRight
                        color: "ghostwhite"
                        visible: model.screenFormat != ""
                    }
                }

                //screening
                Repeater{
                    id:screening
                    Row{
                        height: dateLabel.height
                        width : theaterPage.width
                        visible:   extender.extended

                        Component.onCompleted: {
                            //console.debug(code +" - "+ mCode)
                            screeningTime.model=screeningTimeModel.createObject(screening,{theaterCode:theaterCode,movieCode:mCode,screeningDate:date, xml:theaterMovies.model.xml, versionCode:versionCode, screenFormatCode:screenFormatCode})
                        }


                        Item{
                            height: dateLabel.height
                            width: parent.width

                            Label {
                                id: dateLabel
                                text: DateTools.formatDate(new Date(DateTools.getDateFromFormat(model.date, "yyyy-MM-d")), "EE")
                                elide: Text.ElideRight
                                color: "gold"
                                width: 120
                            }

                            ListView{
                                clip:true
                                height: dateLabel.height
                                orientation: Qt.Horizontal
                                anchors{left:dateLabel.right;right: parent.right; rightMargin:20}
                                id:screeningTime
                                delegate:Component{Row {

                                        Label{
                                            text: "   "+time
                                            color: "ghostwhite"
                                            //elide: Text.ElideRight

                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                ItemExtender {
                    id: extender
                }

            }
        }
    }

    // noShow
    Item {
        id: noShow
        visible: false
        anchors.top:windowTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Loader {
            id: theaterDetailsNoShow
            sourceComponent: theaterDetails
        }

        Rectangle {
            anchors.top: theaterDetailsNoShow.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: "transparent"

            Label {
                anchors.centerIn: parent
                text: "Aucune projection programmée"
                color: "gold"
            }
        }

    }


    PositionSource {
        id: myPosition
        updateInterval: 30000
        active: true
        onPositionChanged: {
            if (position) {
                console.log("lat=" + position.coordinate.latitude)
                active = false
            }
        }
    }
}
