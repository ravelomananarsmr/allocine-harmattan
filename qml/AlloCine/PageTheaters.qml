import QtQuick 1.1
import com.nokia.meego 1.1
import QtMobility.location 1.1
import "Helpers.js" as Helpers
//import com.nokia.symbian 1.1

Page {
    id: theatersPage
    tools: buttonTools
    property real latitude: 0
    property real longitude: 0

    function openFile(file) {
        var component = Qt.createComponent(file)
        if (component.status == Component.Ready)
            pageStack.push(component);
        else
            console.log("Error loading component:", component.errorString());
    }


    PositionSource {
        id: myPosition
        updateInterval: 30000
        active: false
        onPositionChanged: positionUpdated()
//        position.coordinate.longitude: 1.4449450559914112
//        position.coordinate.latitude: 43.59830824658275
    }

    property bool loading: modelTheaters.status == XmlListModel.Loading

    function startSearchMyPosition(){
        console.log("Location update requested")
        theatersPageLoadingOverlay.loadingText = "Recherche de ma position"
        theatersPageLoadingOverlay.visible = true
        theaterListView.visible = false
        myPosition.start()
        //listView.header.searchButton.enabled = false
        aroundMeButton.enabled = false
        // TODO Clear text field
    }

    function positionUpdated(){
        console.log("Location updated: Lat:" + myPosition.position.coordinate.latitude + " Long:" + myPosition.position.coordinate.longitude)
        myPosition.stop()
        latitude = myPosition.position.coordinate.latitude
        longitude = myPosition.position.coordinate.longitude
        theaterListView.model.searchLat = latitude
        theaterListView.model.searchLong = longitude
        theatersPageLoadingOverlay.loadingText = "Recherche de salle à proximité"
        aroundMeButton.enabled = true
    }

    function stopSearchMyPosition(){
        console.log("Cancel location")
        myPosition.stop()
        aroundMeButton.enabled = true
        theatersPageLoadingOverlay.visible = false
        theaterListView.visible = true
    }

    function searchPosition(query){
        console.log("Location searched: " + query)
        if((parseFloat(query) == parseInt(query)) && !isNaN(query)){
            modelTheaters.searchZip = query
        } else {
            modelTheaters.searchLocation = query
        }
    }

    // buttonTools
    ToolBarLayout {
        id: buttonTools

        ToolIcon { iconId: "toolbar-back"; onClicked: { myMenu.close(); pageStack.pop(); }  }
        ToolButtonRow {
            ToolButton {
                id: aroundMeButton
                text: "Autour de moi";
                onClicked: startSearchMyPosition()
            }
        }
        ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: "Salles"
    }

    LoadingOverlay {
        id: theatersPageLoadingOverlay
    }

    ModelTheaters {
        id: modelTheaters
        onStatusChanged: {
            if (status == XmlListModel.Loading){
                //console.log("Model Loading")
                theatersPageLoadingOverlay.visible = true
                theatersPageLoadingOverlay.loadingText = "Recherche de salles"
                theaterListView.visible = false
            } else if (status == XmlListModel.Ready){
                //console.log("Model Ready")
                theatersPageLoadingOverlay.visible = false
                theaterListView.visible = true
            }
        }
        onCountChanged: {
            console.log(count + " theaters found" )
        }
    }

    // theaterListView
    ListView {
        id: theaterListView
        anchors.top: windowTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        model: modelTheaters
        header: ListComponentSearchField {
            id: searchField
            placeholderText: "Ville ou code postal"
            onAccepted: {
                searchPosition(text)
                focus = false
            }
        }

        delegate:  Item {
            id: listItem
            height: 100
            width: parent.width

            Rectangle {
                id: background
                anchors.fill: parent
                // Fill page borders
                anchors.leftMargin: -listPage.anchors.leftMargin
                anchors.rightMargin: -listPage.anchors.rightMargin
                visible: mouseArea.pressed
                color: "#202020"
            }

            Row {
                anchors.fill: parent
                anchors.margins: rootWindow.pageMargin

                Column {
                    anchors.verticalCenter: parent.verticalCenter

                    Label {
                        id: theaterName
                        text: model.name
                        font.weight: Font.Bold
                        font.pixelSize: 26
                        width: listView.width - 30
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        color: "ghostwhite"
                    }

                    Coordinate {
                        id: theaterCoordinate
                        latitude: tlatitude
                        longitude: tlongitude
                    }

                    Label {
                        id: theaterDistance
                        text: "A " + Helpers.formatdistance(theaterCoordinate.distanceTo(myPosition.position.coordinate)) + " de moi"
                        font.weight: Font.Light
                        font.pixelSize: 22
                        width: listView.width - 30
                        elide: Text.ElideRight
                        color: "ghostwhite"
                        visible: myPosition.position.coordinate.latitude || myPosition.position.coordinate.longitude
                    }

                    Label {
                        id: theaterAddress
                        text: model.address + ", "+ model.city
                        font.weight: Font.Light
                        font.pixelSize: 22
                        width: listView.width - 30
                        elide: Text.ElideRight
                        color: "gold"
                        visible: text != ""
                    }
                }
            }

            Image {
                source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea {
                id: mouseArea
                anchors.fill: background
                onClicked: {
                   enabled = false
                   var component = Qt.createComponent("PageTheater.qml")
                   if (component.status == Component.Ready) {
                       console.log("Selected theater: ", model.code);
                       pageStack.push(component, {
                            theaterCode: model.code,
                        });
                       enabled = true
                   } else {
                       console.log("Error loading component:", component.errorString());
                       enabled = true
                    }
                 }
            }
        }
    }

    ScrollDecorator {
        flickableItem: theaterListView
    }

    Menu {
        id: myMenu

        MenuLayout {
            MenuItem { text: "Voir la carte autour de moi";
                       onClicked: {
                    var component = Qt.createComponent("PageTheatersMap.qml")
                    if (component.status == Component.Ready) {
                        console.log("Opening Map centered on lat=" + myPosition.position.coordinate.latitude + " and long = " + myPosition.position.coordinate.longitude);
                        pageStack.push(component);
                    } else {
                        console.log("Error loading component:", component.errorString());
                     }
                  }
            }
            MenuItem { text: "Rayon: 1 km";
                onClicked: {
                    theaterListView.model.searchRadius = 1
                }
            }
            MenuItem { text: "Rayon: 10 km";
                onClicked: {
                    theaterListView.model.searchRadius = 10
                }
            }
            MenuItem { text: "Rayon: 100 km";
                onClicked: {
                    theaterListView.model.searchRadius = 100
                }
            }
        }
    }
}
