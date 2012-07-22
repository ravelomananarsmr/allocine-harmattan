// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1

Item {
    property int animationDuration: 300
    property bool extended: state == "EXTENDED" ? true: false
    anchors.left: parent.left
    anchors.right: parent.right
    height: iconImage.height + separator.height

    state: "RETRACTED"

    states: [
        State {
             name: "RETRACTED"
             PropertyChanges { target: iconImage; rotation: 90 }
         },
        State {
             name: "EXTENDED"
             PropertyChanges { target: iconImage; rotation: 270 }
         }
    ]

    transitions: [
        Transition {
            from: "RETRACTED"
            to: "EXTENDED"
            RotationAnimation {
                target: iconImage
                duration: animationDuration
                direction: RotationAnimation.Clockwise
            }
        },
        Transition {
            from: "EXTENDED"
            to: "RETRACTED"
            RotationAnimation {
                target: iconImage
                duration: animationDuration
                direction: RotationAnimation.Counterclockwise
            }
        }
    ]

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
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }

    onClicked: {
        if (state == "RETRACTED") {
            state = "EXTENDED"
        } else  if (state == "EXTENDED"){
            state = "RETRACTED"
        }
    }

    Component.onCompleted: {
        mouseArea.clicked.connect(clicked)
    }
}
