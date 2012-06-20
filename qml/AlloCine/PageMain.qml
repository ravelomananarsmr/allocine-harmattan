import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: listPage
    orientationLock: PageOrientation.LockPortrait

    WindowTitle {
        id: windowTitleBar
        windowTitle: "AlloCine"
    }

    function openFile(file) {
        var component = Qt.createComponent(file)
        if (component.status == Component.Ready)
            pageStack.push(component);
        else
            console.log("Error loading component:", component.errorString());
    }

    ListModel {
        id: pagesModel
        ListElement {
            page: "PageTheaters.qml"
            title: "Salles"
            subtitle: "Rechercher une salle de cinéma"
        }
        ListElement {
            page: "PageSearchFilms.qml"
            title: "Films"
            subtitle: "Rechercher des films"
        }
//        ListElement {
//            page: "PageSeries.qml"
//            title: "Séries"
//            subtitle: "Rechercher des séries"
//        }
    }

    Flickable {

        id: flickArea
        anchors.top: parent.top
        anchors.topMargin: windowTitleBar.height
        flickableDirection: Flickable.VerticalFlick
        anchors.fill: parent

//        Rectangle {
//            anchors.fill: parent
//            color: "black"
//        }

        Image {
            id: allocineLogo
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            source: "Images/allocine.png"
        }

        ListView {
            id: listView
            //anchors.fill: parent
            //anchors.margins: 16
            anchors.top: allocineLogo.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            model: pagesModel
            interactive: false

            delegate:  Item {
                id: listItem
                height: 88
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
                    anchors.margins: 16

                    Column {
                        anchors.verticalCenter: parent.verticalCenter

                        Label {
                            id: mainText
                            color: "ghostwhite"
                            text: model.title
                            font.weight: Font.Bold
                            font.pixelSize: 26
                        }

                        Label {
                            id: subText
                            text: model.subtitle
                            font.weight: Font.Light
                            font.pixelSize: 22
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
                        listPage.openFile(page)
                    }
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: flickArea
    }
}
