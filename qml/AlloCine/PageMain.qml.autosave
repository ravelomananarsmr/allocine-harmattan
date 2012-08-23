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
            subtitle: "Rechercher un film"
        }
        ListElement {
            page: "PageSearchPersons.qml"
            title: "Personnes"
            subtitle: "Rechercher une personne"
        }
    }

     ListView {
        id: listView
        anchors.top: windowTitleBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        model: pagesModel
       /*  TO BE REMOVED */
        Rectangle {
            anchors.fill: parent
            color: "red"
            MouseArea{
                anchors.fill: parent
                onClicked: shareString.share("eeee")
            }
        }
    /*************************/
         header: Image {
             id: allocineLogo
            width: listPage.width * 0.9
            smooth: true
            fillMode: Image.PreserveAspectFit
//            anchors.top: parent.top
//            anchors.horizontalCenter: parent.horizontalCenter
            source: "Images/allocine.png"
        }

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
