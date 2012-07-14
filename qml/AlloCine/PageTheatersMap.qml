import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.location 1.2

Page {
    id: mapPage
    tools: buttonTools

    property int nb_of_theaters: 0


    // buttonTools
    ToolBarLayout {
        id: buttonTools

        ToolIcon { iconId: "toolbar-back"; onClicked: { me.stop(); myMenu.close(); pageStack.pop(); }  }
        ToolButtonRow {
            ToolButton {
                id: aroundMeButton
                checkable: true
                checked: true
                text: "Centrer sur moi";
                onCheckedChanged: {console.log("Auto center: " + aroundMeButton.checked); me.active = aroundMeButton.checked}
            }
        }
        ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
    }
    Menu {
        id: myMenu
        visualParent: pageStack

        MenuLayout {
            MenuItem { text: "Carte"; onClicked: map.mapType = Map.StreetMap }
            MenuItem { text: "Satellite"; onClicked: map.mapType = Map.SatelliteMapDay }
        }
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: nb_of_theaters + " salles dans un rayon de " + pinpointView.model.radius + " km"
    }

    Item {
        anchors.top: windowTitleBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Map {
            anchors.fill: parent
            id: map
            z: 1
            plugin : Plugin {
                name : "nokia";

                //! Location requires usage of app_id and token parameters.
                //! Values below are for testing purposes only, please obtain real values.
                //! Go to https://api.developer.nokia.com/ovi-api/ui/registration?action=list.
                parameters: [
                    PluginParameter { name: "app_id"; value: "H3qCZPYFilcJr1GvtqDc" },
                    PluginParameter { name: "token"; value: "izFGwW9LLoKmqUOMmjpJMQ" }
               ]
            }
            center: me.position.coordinate
            mapType: Map.StreetMap
            zoomLevel: 14

            ZoomButton {
                anchors.margins: 16
                anchors.top: parent.top
                anchors.left: parent.left
                width: 70
                height: 70
                id: plus
                value: "+"
                onClicked: map.zoomLevel += 1
            }
            ZoomButton {
                anchors.topMargin: 10
                anchors.top: plus.bottom
                anchors.left: plus.left
                width: 70
                height: 70
                id: minus
                value: "-"
                onClicked: map.zoomLevel -= 1
            }

            //! Icon to display the current position
            MapImage {
                id: mapPlacer
                source: "Images/pinpoint-me.png"
                coordinate: me.position.coordinate

                /*!
                 * We want that bottom middle edge of icon points to the location, so using offset parameter
                 * to change the on-screen position from coordinate. Values are calculated based on icon size,
                 * in our case icon is 48x48.
                 */
                offset.x: -34
                offset.y: -68

                z:3

                Component.onCompleted: console.log("My position pinpoint added: " + coordinate.latitude + "/" + coordinate.longitude + " visible=" + visible + " x=" + x + " y=" + y)

            }

            Repeater {
                id: pinpointView
                anchors.fill: parent
                model: ModelTheaters {

                    query : "/feed/theater"

                    onStatusChanged: {
                        if (status == XmlListModel.Loading){
                            console.log("Model Loading")
                        } else if (status == XmlListModel.Ready){
                            console.log("Model Ready")
                        }
                    }
                    onCountChanged: {
                        console.log(count + " theater found" )
                        nb_of_theaters = count
                    }
                }

                delegate: ItemTheaterMap {

                    theaterCoordinate: Coordinate {
                        latitude: parseFloat(tlatitude)
                        longitude: parseFloat(tlongitude)
                    }

                    theaterName: name

                    z: 2

    //                onSelected: {
    //                    //theaterName = modelTheaters.get(index).name
    //                    console.log("Selected Theater: " + model.name)
    //                    //station.source = "http://www.velib.paris.fr/service/stationdetails/" + stations.get(index).number
    //                }
                }
            }
        }

        //! Panning and pinch implementation on the maps
        PinchArea {
            id: pincharea

            //! Holds previous zoom level value
            property double __oldZoom

            anchors.fill: parent

            //! Calculate zoom level
            function calcZoomDelta(zoom, percent) {
                return zoom + Math.log(percent)/Math.log(2)
            }

            //! Save previous zoom level when pinch gesture started
            onPinchStarted: {
                __oldZoom = map.zoomLevel
            }

            //! Update map's zoom level when pinch is updating
            onPinchUpdated: {
                map.zoomLevel = calcZoomDelta(__oldZoom, pinch.scale)
            }

            //! Update map's zoom level when pinch is finished
            onPinchFinished: {
                map.zoomLevel = calcZoomDelta(__oldZoom, pinch.scale)
            }
        }

        //! Map's mouse area for implementation of panning in the map and zoom on double click
        MouseArea {
            id: mousearea

            //! Property used to indicate if panning the map
            property bool __isPanning: false

            //! Last pressed X and Y position
            property int __lastX: -1
            property int __lastY: -1

            anchors.fill : parent

            //! When pressed, indicate that panning has been started and update saved X and Y values
            onPressed: {
                __isPanning = true
                __lastX = mouse.x
                __lastY = mouse.y
            }

            //! When released, indicate that panning has finished
            onReleased: {
                __isPanning = false
            }

            //! Move the map when panning
            onPositionChanged: {
                if (__isPanning) {
                    var dx = mouse.x - __lastX
                    var dy = mouse.y - __lastY
                    map.pan(-dx, -dy)
                    __lastX = mouse.x
                    __lastY = mouse.y
                }
            }

            //! When canceled, indicate that panning has finished
            onCanceled: {
                __isPanning = false;
            }

            //! Zoom one level when double clicked
            onDoubleClicked: {
                map.center = map.toCoordinate(Qt.point(__lastX,__lastY))
                map.zoomLevel += 1
            }
        }
    }

    //! Source for retrieving the positioning information
    PositionSource {
        id: me

        //! Desired interval between updates in milliseconds
        updateInterval: 10000
        active: true

        //! When position changed, update the location strings
        onPositionChanged: {
            console.log("My position changed")
            if (aroundMeButton.checked) {
                map.center = me.position.coordinate
            }
            pinpointView.model.searchQuery = "lat=" + map.center.latitude + "&long=" + map.center.longitude

        }
    }
}
