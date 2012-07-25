import QtQuick 1.1
import com.nokia.meego 1.1
import "Helpers.js" as Helpers
import "DateTools.js" as DateTools

Page {
    id: pagePicture
    tools: buttonTools

    property string imageSource
    property string title

    ToolBarLayout {
        id: buttonTools

        ToolIcon { iconId: "toolbar-back"; onClicked: {pageStack.pop(); }  }
//        ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
    }

    Rectangle {
        id: background
        color: "black"
        anchors.fill: parent
    }

    LoadingOverlay {
        id: pagePictureLoadingOverlay
    }

    Flickable {
        id: flick
        anchors.centerIn: parent
        anchors.fill: parent

        contentWidth: pagePicture.width
        contentHeight: pagePicture.height

        PinchArea {
            id: picturePinchArea
            width: Math.max(flick.contentWidth, flick.width)
            height: Math.max(flick.contentHeight, flick.height)

            property real initialWidth
            property real initialHeight

            onPinchStarted: {
                initialWidth = flick.contentWidth
                initialHeight = flick.contentHeight
            }

            onPinchUpdated: {
                // adjust content pos due to drag
                flick.contentX += pinch.previousCenter.x - pinch.center.x
                flick.contentY += pinch.previousCenter.y - pinch.center.y

                // resize content
                flick.resizeContent(initialWidth * pinch.scale, initialHeight * pinch.scale, pinch.center)
            }

            onPinchFinished: {
                // Move its content within bounds.
                flick.returnToBounds()
            }

        }

        Rectangle {

            width: flick.contentWidth
            height: flick.contentHeight
            anchors.centerIn: parent
            color: "black"
            Image {
                id: pictureImage
                anchors.fill: parent
                source: imageSource
                fillMode: Image.PreserveAspectFit
                smooth: true
                MouseArea {
                    anchors.fill: parent
                    onDoubleClicked: {
                        flick.contentWidth = pagePicture.width
                        flick.contentHeight = pagePicture.height
                    }
                }
            }
        }

//        Menu {
//            id: myMenu

//            MenuLayout {
//                MenuItem { text: "Enregistrer l'image";
//                    onClicked: {

//                    }
//                }
//    //            MenuItem { text: "Partager";
//    //                onClicked: {
//    //                    Qt.openUrlExternally(linkWeb)
//    //                    console.log("Opening URL: " + linkWeb)
//    //                }
//    //            }
//            }
    }
}
