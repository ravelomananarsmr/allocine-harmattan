import QtQuick 1.1
import com.nokia.meego 1.1
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

MapImage {

    id: itemTheaterMap

    property variant theaterCode

    source: "Images/pinpoint-theater.png"
    coordinate: Coordinate{}
    /*!
         * We want that bottom middle edge of icon points to the location, so using offset parameter
         * to change the on-screen position from coordinate. Values are calculated based on icon size,
         * in our case icon is 48x48.
         */
    offset.x: -34
    offset.y: -69
    visible:true
    //Component.onCompleted: console.log("Pinpoint added: " + itemTheaterMap.theaterName + " " + coordinate.latitude + "/" + coordinate.longitude+"   "+status)

    MapMouseArea {
        anchors.fill: parent
        onClicked: {
            var component = Qt.createComponent("PageTheater.qml")
            if (component.status == Component.Ready) {
                console.log("Selected theater: ", theaterCode);
                pageStack.push(component, {
                     theaterCode: theaterCode,
                 });
            } else {
                console.log("Error loading component:", component.errorString());
             }
        }
    }

}
