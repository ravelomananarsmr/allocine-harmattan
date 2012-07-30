// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import QtMobility.location 1.2
import "DateTools.js" as DateTools
import "Helpers.js" as Helpers

Page {
    id: theaterPage
    tools: buttonTools

    property string name: ""
    property string theaterCode: ""
    property date showDate

    ToolBarLayout {
        id: buttonTools
        ToolIcon { iconId: "toolbar-back"; onClicked: { myPosition.stop(); myMenu.close(); pageStack.pop(); }  }
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: "Cinéma " + name
    }

    Component {
        id: theaterDetails
        //onCompleted: myPosition.start()

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
                    latitude: tlatitude
                    longitude: tlongitude
                }

                MapImage {
                    id: theaterMarker
                    //width: 50
                    //height: 50
                    offset.x: -71/2
                    offset.y: -71
                    source: "Images/marker.png"
                    coordinate: theaterCoordinate
                }

                //                MapCircle {
                //                    id: theaterPositionExternalLine
                //                    color: "black"
                //                    radius: 20
                //                    center: theaterCoordinate
                //                }

                //                MapCircle {
                //                    id: theaterPositionExternal
                //                    color: "white"
                //                    radius: 19
                //                    center: theaterCoordinate
                //                }

                //                MapCircle {
                //                    id: theaterPositionInternal
                //                    color: "gold"
                //                    radius: 15
                //                    center: theaterCoordinate
                //                }

                MapCircle {
                    id: myPositionExternalLine
                    color: "black"
                    radius: 20
                    center: myPosition.position.coordinate
                }

                MapCircle {
                    id: myPositionExternal
                    color: "white"
                    radius: 19
                    center: myPosition.position.coordinate
                }

                MapCircle {
                    id: myPositionInternal
                    color: "green"
                    radius: 15
                    center: myPosition.position.coordinate
                }

                MouseArea {
                    id: mapMouseArea
                    anchors.fill: parent
                    onPressed: {
                        Qt.openUrlExternally("geo:" + theaterCoordinate.latitude + "," + theaterCoordinate.longitude)
                        //                        var component = Qt.createComponent("PageTheatersMap.qml")
                        //                        if (component.status == Component.Ready) {
                        //                            console.log("Opening Map centered on lat=" + theaterCoordinate.latitude + " and long = " + theaterCoordinate.longitude);
                        //                            pageStack.push(component, {centerCoordinate: theaterCoordinate});
                        //                        } else {
                        //                            console.log("Error loading component:", component.errorString());
                        //                         }
                    }
                }

            }

            Column {
                anchors.margins: 16
                id: theaterDetailsText

                Label {
                    id: theaterAddressLabel
                    text: address
                    color: "ghostwhite"
                }
                Label {
                    id: cityLabel
                    text: postalCode + " " + city
                    color: "ghostwhite"
                }
                Label {
                    id: distanceLabel
                    text: Helpers.formatdistance(theaterCoordinate.distanceTo(myPosition.position.coordinate)) + " de moi"
                    color: "gold"
                }

                Label {
                    text: "Type: " + cinemaChain
                    color: "ghostwhite"
                }
                Label {
                    text: "Ecrans: " + screenCount
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
        theaterCode: code
        showDate: showDate
        onStatusChanged: {
            if (status == XmlListModel.Loading){
                //console.log("Model Loading")
            } else if (status == XmlListModel.Ready){
                showDate = new Date();
                //console.log("Model Ready, today=" + Qt.formatDateTime(showDate, "yyyy-MM-dd"))
                //console.log("//feed/theaterShowtimes[place/theater/@code/string()=\""+theaterCode+"\" and movieShowtimesList/movieShowtimes/screenings/scr/@d/string()=\""+ Qt.formatDateTime(showDate, "yyyy-MM-dd") + "\"]/movieShowtimesList/movieShowtimes")
                if (theaterMovies.model.xml){ // To be sure there is somthing loaded
                    if (count > 0){
                        theaterPageLoadingOverlay.visible = false
                        noShow.visible = false
                        //theaterMovies.visible = true
                    } else {
                        //console.log("No movie for this theater")
                        noShow.visible = true
                        theaterMovies.visible = false
                        theaterPageLoadingOverlay.visible = false
                    }
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
                    screening.model=screeningDateModel.createObject(screening,{theaterCode:code,movieCode:mCode, xml:theaterMovies.model.xml, versionCode:versionCode, screenFormatCode:screenFormatCode})
                }

                Rectangle {
                    id: detailsRow
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: Math.max(detailsItem.height,posterImageContainer.height)
                    color: "transparent"

                    MouseArea {
                        id: mouseArea
                        anchors.fill: detailsRow
                        onClicked: {
                            var component = Qt.createComponent("PageFilm.qml")
                            if (component.status == Component.Ready) {
                                console.log("Selected movie: ", model.mCode);
                                pageStack.push(component, {
                                                   mCode: model.mCode,
                                                   title: model.title
                                               });
                            } else {
                                console.log("Error loading component:", component.errorString());
                            }
                            detailsRow.color = "transparent"
                        }
                        onPressed: detailsRow.color = "#202020"
                        onCanceled: detailsRow.color = "transparent"
                    }

                    //posterImageContainer
                    Rectangle {
                        id: posterImageContainer
                        width: posterImage.width + 8
                        height: Math.max(posterImage.height, 133) + 8
                        anchors.top: parent.top
                        anchors.verticalCenter: parent.verticalCenter
                        color: "black"
                        z:1

                        Rectangle {
                            id: posterWhiteOutline
                            width: posterImage.width + 6
                            height: Math.max(posterImage.height, 133) + 6
                            anchors.centerIn: parent
                            color: "white"
                            z:2

                            Image {
                                id: noPosterImage
                                source: "Images/empty.png"
                                width: 100
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                z:3
                            }

                            Image {
                                id: posterImage
                                source: (model.poster? model.poster: "Images/empty.png")
                                width: 100
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                z:4
                            }
                        }
                    }

                    // detailsItem
                    Column {
                        id: detailsItem
                        anchors.leftMargin: 10
                        anchors.left: posterImageContainer.right
                        width: theaterPage.width - posterImageContainer.width - arrow.width - 20

                        // titleLabel
                        Label {
                            id: titleLabel
                            text: model.title
                            font.weight: Font.Bold
                            font.pixelSize: 26
                            width: parent.width
                            //width: listView.width - 110
                            //maximumLineCount: 1
                            color: "gold"
                            elide: Text.ElideRight
                        }

                        // directorsLabel
                        Label {
                            id: directorsLabel
                            text: "De " + model.directors
                            //width: listView.width - 110
                            width: parent.width
                            color: "ghostwhite"
                            elide: Text.ElideRight
                        }

                        // actorsLabel
                        Label {
                            id: actorsLabel
                            text: "Avec " + model.actors
                            width: parent.width
                            //width: listView.width - 110
                            color: "ghostwhite"
                            elide: Text.ElideRight
                        }

                        // versionRuntimeRow
                        Row {
                            id: versionRuntimeRow

                            Label {
                                id: versionLabel
                                text: model.version
                                font.weight: Font.Light
                                font.pixelSize: 22
                                elide: Text.ElideRight
                                color: "ghostwhite"
                                visible: model.version != ""
                            }

                            Label {
                                text: " - "
                                font.weight: Font.Light
                                font.pixelSize: 22
                                elide: Text.ElideRight
                                color: "ghostwhite"
                                visible: model.version != ""
                            }

                            Label {
                                id: screenFormatLabel
                                text: model.screenFormat
                                font.weight: Font.Light
                                font.pixelSize: 22
                                elide: Text.ElideRight
                                color: "ghostwhite"
                                visible: model.screenFormat != ""
                            }

                            Label {
                                text: " - "
                                font.weight: Font.Light
                                font.pixelSize: 22
                                elide: Text.ElideRight
                                color: "ghostwhite"
                                visible: model.screenFormat != ""
                            }

                            Label {
                                id: runtimeLabel
                                text: Helpers.formatSecondsAsTime(model.runtime, 'hh:mm')
                                font.weight: Font.Light
                                font.pixelSize: 22
                                elide: Text.ElideRight
                                color: "ghostwhite"
                                visible: model.runtime != ""
                            }
                        }

                        //                        // versionRuntimeLabel
                        //                        Label {
                        //                            id: versionRuntimeLabel
                        //                            text: model.version + " - " + model.screenFormat + " " + Helpers.formatSecondsAsTime(model.runtime, 'hh:mm')
                        //                            font.weight: Font.Light
                        //                            font.pixelSize: 22
                        //                            width: parent.width
                        //                            //width: listView.width - 110
                        //                            elide: Text.ElideRight
                        //                            color: "ghostwhite"
                        //                            visible: text != ""
                        //                        }

                    }

                    // arrow
                    Image {
                        id: arrow
                        anchors.right: parent.right
                        source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }

                //showTimesLabel
                Label {
                    id: showTimesLabel
                    text: "Séances"
                    color: "gold"
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible:   !extender.extended
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
                            screeningTime.model=screeningTimeModel.createObject(screening,{theaterCode:code,movieCode:mCode,screeningDate:date, xml:theaterMovies.model.xml, versionCode:versionCode, screenFormatCode:screenFormatCode})
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

}
