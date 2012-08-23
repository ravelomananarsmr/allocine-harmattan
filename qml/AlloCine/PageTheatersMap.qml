import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.location 1.2

Page {
    id: mapPage
    tools: buttonTools

    property int nb_of_theaters: 0
    property Coordinate centerCoordinate
    property bool aroundMe: true

    // buttonTools
    ToolBarLayout {
        id: buttonTools

        ToolIcon { iconId: "toolbar-back"; onClicked: { me.stop(); myMenu.close(); pageStack.pop(); }  }
        ToolButtonRow {
            ToolButton {
                id: aroundMeButton
                checkable: true
                checked: aroundMe
                text: "Centrer sur moi";
                onCheckedChanged: {
                    console.log("Auto center: " + aroundMeButton.checked);
                    me.active = aroundMeButton.checked
                    if (checked) {
                        aroundMe = true
                        if (me.active && !me.position){
                            theatersMapPageLoadingOverlay.show()
                        }
                    } else {
                        aroundMe = false
                        theatersMapPageLoadingOverlay.hide()
                    }
                }
            }
        }
        ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
    }
    Menu {
        id: myMenu

        MenuLayout {
            MenuItem { text: "Carte"; onClicked: map.mapType = Map.StreetMap }
            MenuItem { text: "Satellite"; onClicked: map.mapType = Map.SatelliteMapDay }
            MenuItem { text: "Rayon: 1 km";
                onClicked: {
                    pinpointModel.searchRadius = 1
                }
            }
            MenuItem { text: "Rayon: 10 km";
                onClicked: {
                    pinpointModel.searchRadius = 10
                }
            }
            MenuItem { text: "Rayon: 100 km";
                onClicked: {
                    pinpointModel.searchRadius = 100
                }
            }
        }
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: aroundMe ? "Salles à proximité" : "Carte des salles"
    }

    LoadingOverlay {
        id: theatersMapPageLoadingOverlay
        visible: aroundMe
        loadingText: "Recherche de ma position"
    }

    Item {
        anchors.top: windowTitleBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        id: mapItem
        visible: !theatersMapPageLoadingOverlay.visible

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
            center: centerCoordinate
            mapType: Map.StreetMap
            zoomLevel: 14

            onCenterChanged: {
                // To update the pinpoints when the user drag the map
//                pinpointModel.searchLat = map.center.latitude
//                pinpointModel.searchLong = map.center.longitude
            }

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
                visible: aroundMe

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

            ModelTheaters {
                id:pinpointModel
                query : "/feed/theater"

                onStatusChanged: {
                    if (status == XmlListModel.Loading){
                        console.log("Model Loading")
                    } else if (status == XmlListModel.Ready && xml){
                        console.log("Model Ready")
                        theatersMapPageLoadingOverlay.visible = false
                        mapItem.visible = true
                        windowTitleBar.windowTitle = nb_of_theaters + " salles dans un rayon de " + pinpointModel.searchRadius + " km"

                        for(var i=0; i<count;i++)
                        {
                            // Direct list access
                            var component = Qt.createComponent("ItemTheaterMap.qml");
                            if (component.status == Component.Ready) {
                                 var pin =component.createObject(map);
                                pin.coordinate.latitude=parseFloat(get(i).tlatitude)
                                pin.coordinate.longitude=parseFloat(get(i).tlongitude)
                                pin.theaterCode=get(i).code
                                map.addMapObject(pin)
                            }
                        }


                    }
                }
                onCountChanged: {
                    console.log(count + " theater found" )
                    nb_of_theaters = count
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
        active: false

        Component.onCompleted: {
            pinpointModel.searchLat = centerCoordinate.latitude
            pinpointModel.searchLong = centerCoordinate.longitude
        }

        //! When position changed, update the location strings
        onPositionChanged: {
            console.log("My position changed")
            theatersMapPageLoadingOverlay.loadingText = "Recherche de salle à proximité"
            if (aroundMeButton.checked) {
                //            map.center.latitude = 43.59830824658275
                //            map.center.longitude =  1.4449450559914112
                map.center = me.position.coordinate
            }
            // To be removed if we want to activate refresh on dragging the map
            pinpointModel.searchLat = me.position.coordinate.latitude
            pinpointModel.searchLong = me.position.coordinate.longitude

        }
    }
}
