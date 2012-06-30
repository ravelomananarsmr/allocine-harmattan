// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    property bool extenderOpened:false
    anchors.left: parent.left
    anchors.right: parent.right
    height: iconImage.height + separator.height

    signal clicked()

    Rectangle {
        id: background
        anchors.fill: parent
        visible: mouseArea.pressed
        color: colorSelectedListItem
    }

    Rectangle {
        id: separator
        height: 1
        color: "ghostwhite"
    }

    Image {
        id: iconImage
        anchors.top: separator.bottom
        source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
        anchors.horizontalCenter: parent.horizontalCenter
        rotation: (extenderOpened ?270 :90  )
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }

    onClicked: {
       extenderOpened = ! extenderOpened
    }

    Component.onCompleted: {
        mouseArea.clicked.connect(clicked)
    }
}
