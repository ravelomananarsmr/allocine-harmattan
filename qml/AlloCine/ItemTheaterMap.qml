import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.location 1.2

//Item {
//    signal selected(int index)
//    property variant coord: Coordinate {
//        latitude: parseFloat(tlatitude)
//        longitude: parseFloat(tlongitude)
//    }
//    x: map.toScreenPosition(coord).x + map.anchors.topMargin
//    y: map.toScreenPosition(coord).y + map.anchors.leftMargin

//    Component.onCompleted: console.log("Theater showed: " + name)
//    Image {
//        id: icon
//        z:2
//        anchors.horizontalCenter: parent.center
//        anchors.bottom: parent.bottom
//        source: "Images/pinpoint-theater.png"
//        MouseArea {
//            anchors.fill: parent
//            onClicked: {
//                console.log("Theater" + index + " clicked")
//                selected(index)
//            }
//        }
//    }
//}

Item {

    id: itemTheaterMap

    property variant theaterName
    property variant theaterCoordinate

    MapImage {
        source: "Images/pinpoint-theater.png"
        coordinate: itemTheaterMap.theaterCoordinate

        /*!
         * We want that bottom middle edge of icon points to the location, so using offset parameter
         * to change the on-screen position from coordinate. Values are calculated based on icon size,
         * in our case icon is 48x48.
         */
        offset.x: -34
        offset.y: -69

        Component.onCompleted: console.log("Pinpoint added: " + itemTheaterMap.theaterName + " " + coordinate.latitude + "/" + coordinate.longitude)
    }

}
