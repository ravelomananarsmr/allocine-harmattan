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

    LoadingOverlay {
        id: castingOverlay
        visible: castingModel.status == XmlListModel.Loading
    }

    ListView {
        id: castingListView
        anchors.top: parent.top
        anchors.topMargin: windowTitleBar.height
        anchors.fill: parent
        Component.onCompleted: castingListView.model = castingModel.createObject(castingModel,{mCode:mCode})

        delegate: Item {
            id: listItem
            height: posterImageContainer.height + 20
            width: parent.width

            Rectangle {
                id: background
                anchors.left: parent.left
                anchors.right: parent.right
                height: Math.max(detailsItem.height,posterImageContainer.height)
                color: "transparent"

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
                        background.color = "transparent"
                     }
                    onPressed: background.color = "#202020"
                    onCanceled: background.color = "transparent"
                }

                //posterImageContainer
                Rectangle {
                    id: posterImageContainer
                    width: posterImage.width + 8
                    height: Math.max(posterImage.height, 133) + 8
                    anchors.top: parent.top
                    anchors.verticalCenter: parent.verticalCenter
                    color: "black"
                    z:1

                    Rectangle {
                        id: posterWhiteOutline
                        width: posterImage.width + 6
                        height: Math.max(posterImage.height, 133) + 6
                        anchors.centerIn: parent
                        color: "white"
                        z:2

                        Image {
                            id: noPosterImage
                            source: "Images/empty.png"
                            width: 100
                            fillMode: Image.PreserveAspectFit
                            anchors.centerIn: parent
                            z:3
                        }

                        Image {
                            id: posterImage
                            source: (model.picture? model.picture: "Images/empty.png")
                            width: 100
                            fillMode: Image.PreserveAspectFit
                            anchors.centerIn: parent
                            z:4
                        }
                    }
                }

                // detailsItem
                Column {
                    id: detailsItem
                    anchors.leftMargin: 10
                    anchors.left: posterImageContainer.right
                    width: castingPage.width - posterImageContainer.width - arrow.width - 20

                    // nameLabel
                    Label {
                        id: nameLabel
                        text: model.name
                        font.weight: Font.Bold
                        font.pixelSize: 26
                        width: parent.width
                        color: "gold"
                        elide: Text.ElideRight
                        visible: model.name
                    }

                    // activityLabel
                    Label {
                        id: activityLabel
                        text: model.activity
                        width: parent.width
                        color: "ghostwhite"
                        elide: Text.ElideRight
                        visible: model.activity
                    }

                    // roleLabel
                    Label {
                        id: roleLabel
                        text: "Rôle: " + model.role
                        width: parent.width
                        //width: listView.width - 110
                        color: "ghostwhite"
                        elide: Text.ElideRight
                        visible: model.role
                    }
                }

                // arrow
                Image {
                    id: arrow
                    anchors.right: parent.right
                    source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
                    anchors.verticalCenter: parent.verticalCenter
                }

            }
        }
    }

    ScrollDecorator {
        flickableItem: castingListView
    }

}
