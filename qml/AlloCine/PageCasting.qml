import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: castingPage
    tools: buttonTools

    property string title

    ToolBarLayout {
        id: buttonTools
        ToolIcon { iconId: "toolbar-back"; onClicked: {pageStack.pop(); }  }
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: "Casting: " + title
    }
    ListView {
        id: castingListView
        anchors.top: parent.top
        anchors.topMargin: windowTitleBar.height
        anchors.fill: parent
        Component.onCompleted: castingListView.model = castingModel.createObject(castingModel,{mCode:mCode})

        delegate: Item {
            height: Math.max(personDetails.height, personPictureContainer.height) + 20
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
                spacing: 10

                Rectangle {
                    id: personPictureContainer
                    width: personPicture.width + 8
                    height: Math.max(personPicture.height, 133) + 8
                    anchors.top: parent.top
                    anchors.verticalCenter: parent.verticalCenter
                    color: "black"

                    z:1

                    Rectangle {
                        id: personPictureWhiteOutline
                        width: personPicture.width + 6
                        height: Math.max(personPicture.height, 133) + 6
                        anchors.centerIn: parent
                        color: "white"
                        z:2

                        Image {
                            id: noPersonPicture
                            source: "Images/empty.png"
                            width: 100
                            anchors.top: parent.top
                            anchors.verticalCenter: parent.verticalCenter
                            fillMode: Image.PreserveAspectFit
                            anchors.centerIn: parent
                            z:3
                        }

                        Image {
                            id: personPicture
                            source: (model.picture? model.picture: "Images/empty.png")
                            width: 100
                            anchors.top: parent.top
                            anchors.verticalCenter: parent.verticalCenter
                            fillMode: Image.PreserveAspectFit
                            anchors.centerIn: parent
                            z:4
                        }
                    }
                }

//                Image {
//                    id: personPicture
//                    source: model.picture
//                    width: 80
//                    anchors.top: parent.top
//                    anchors.verticalCenter: parent.verticalCenter
//                    fillMode: Image.PreserveAspectFit
//                }

                Column {
                    id: personDetails
                    width: castingPage.width - personPictureContainer.width - /*arrow.width*/ - 20

                    Label {
                        id: personLabelActivity
                        text: model.name
                        font.weight: Font.Bold
                        font.pixelSize: 26
                        width: parent.width
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        color: "gold"
                    }
                    Label {
                        id: personLabelName
                        text: model.activity
                        width: parent.width
                        elide: Text.ElideRight
                        color: "ghostwhite"
                    }
                    Label {
                        id: personLabelRole
                        text: (model.role ? "Rôle: " + model.role : "")
                        width: parent.width
                        elide: Text.ElideRight
                        color: "ghostwhite"
                    }
                }
            }


            Image {
                id: arrow
                source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea {
                id: mouseArea
                anchors.fill: background
                onClicked: {
                    var component = Qt.createComponent("PagePerson.qml")
                    if (component.status == Component.Ready) {
                        console.log("Selected person: ", model.personCode);
                        pageStack.push(component, {
                            personCode: model.personCode,
                            name: model.name
                         });
                    } else {
                        console.log("Error loading component:", component.errorString());
                     }
                 }
            }
        }
    }

    ScrollDecorator {
        flickableItem: castingListView
    }

}
