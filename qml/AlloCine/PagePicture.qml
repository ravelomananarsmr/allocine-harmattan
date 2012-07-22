import QtQuick 1.1
import com.nokia.meego 1.1
import "Helpers.js" as Helpers
import "DateTools.js" as DateTools

Page {
    id: pagePicture
    tools: buttonTools

    property string imageSource
    property string title

    property int animationDuration: 300

    state: "DECORATED"

    states: [
        State {
             name: "DECORATED"
             PropertyChanges { target: windowTitleBar; opacity: 1 }
             PropertyChanges { target: buttonTools; opacity: 1 }
         },
        State {
             name: "NOT_DECORATED"
             PropertyChanges { target: windowTitleBar; opacity: 0 }
             PropertyChanges { target: buttonTools; opacity: 0 }
        }
    ]

    transitions: [
        Transition {
            from: "DECORATED"
            to: "NOT_DECORATED"
            PropertyAnimation {
                target: windowTitleBar
                duration: animationDuration
                property: "opacity"
            }
            PropertyAnimation {
                target: buttonTools
                duration: animationDuration
                property: "opacity"
            }
            reversible: true
        }
    ]

    ToolBarLayout {
        id: buttonTools

        ToolIcon { iconId: "toolbar-back"; onClicked: {pageStack.pop(); }  }
        //ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
    }

    Rectangle {
        id: background
        color: "black"
        anchors.fill: parent
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: title
        windowTitleBackup: "Pas de titre"
    }

    LoadingOverlay {
        id: pagePictureLoadingOverlay
    }

    Item {
        anchors.top: windowTitleBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        MouseArea {
            id: pictureMouseArea
            anchors.fill: picture
            onClicked: {
                if (pagePicture.state == "DECORATED") {
                    pagePicture.state = "NOT_DECORATED"
                } else  if (pagePicture.state == "NOT_DECORATED"){
                    pagePicture.state = "DECORATED"
                }
            }
        }

        Image {
            id: picture
            source: imageSource
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            smooth: true
        }
    }
}
