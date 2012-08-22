import QtQuick 1.1
import com.nokia.meego 1.1
import "Helpers.js" as Helpers
import "DateTools.js" as DateTools

Page {
    id: pagePerson
    tools: buttonTools

    orientationLock: PageOrientation.LockPortrait
    property int personCode
    property string name

    ModelPerson {
        id: modelPerson
        personCode: pagePerson.personCode
        onStatusChanged: {
            //console.log("person code = " + pagePerson.personCode)
            if (status == XmlListModel.Ready && count > 0){
                pagePersonLoadingOverlay.visible = false
            } else if (status == XmlListModel.Ready && count > 0) {
                console.log("Model ready but count = 0")
            }
        }
    }


    ToolBarLayout {
        id: buttonTools

        ToolIcon { iconId: "toolbar-back"; onClicked: {pageStack.pop(); }  }
        //ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: name
        windowTitleBackup: "Illustre Inconnu"
    }



    LoadingOverlay {
        id: pagePersonLoadingOverlay
        onVisibleChanged: {
            if (visible) {
                personListView.visible = false
            } else {
                personListView.visible = true
            }
        }
    }

    ListView {
        id: personListView
        anchors.top: parent.top
        anchors.topMargin: windowTitleBar.height
        anchors.margins: pageMargin
        anchors.fill: parent
        Component.onCompleted: {
            pagePersonLoadingOverlay.visible = true
            pagePersonLoadingOverlay.loadingText = "Chargement du profil"
        }
        model: modelPerson

        delegate: Column {
            width: parent.width
            spacing: pageMargin

            Item {
                width: parent.width
                height: Math.max(pictureBlackOutline.height, mainDetails.height)

                // posterImage
                Rectangle {
                    id: pictureBlackOutline
                    width: pictureImage.width + 7
                    height: pictureImage.height + 7
                    color: "black"
                    z:1

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        enabled: model.picture
                        onClicked: {
                            var component = Qt.createComponent("PagePicture.qml")
                            if (component.status == Component.Ready) {
                                pageStack.push(component, {imageSource: model.picture? model.picture: "Images/empty.png", title: name});
                            } else {
                                console.log("Error loading component:", component.errorString());
                            }
                        }
                    }


                    Rectangle {
                        id: pictureWhiteOutline
                        width: pictureImage.width + 5
                        height: pictureImage.height + 5
                        anchors.centerIn: parent
                        color: "white"
                        z:2

                        Image {
                            id: noPictureImage
                            source: "Images/empty.png"
                            width: 150
                            fillMode: Image.PreserveAspectFit
                            anchors.centerIn: parent
                            z:3
                        }

                        Image {
                            id: pictureImage
                            source: (model.picture? model.picture: "Images/empty.png")
                            width: 150
                            fillMode: Image.PreserveAspectFit
                            anchors.centerIn: parent
                            z:4
                        }
                    }
                }

                // mainDetails
                Column{
                    id: mainDetails
                    anchors.left: pictureBlackOutline.right
                    anchors.leftMargin: pageMargin
                    anchors.right: parent.right
                    anchors.top: parent.top
                    Text {
                        id: personName
                        text: model.givenName + " " + model.familyName
                        width: parent.width
                        wrapMode: Text.Wrap
                        font.weight: Font.Bold
                        font.pointSize: fontSizeLarge
                        color: "ghostwhite"
                    }

                    Label {
                        id: personGender
                        text: (model.gender == "1") ? "Homme" : "Femme"
                        width: parent.width
                        wrapMode: Text.Wrap
                        color: "gold"
                        visible: model.gender
                    }

                    Label {
                        id: personActivityShort
                        text: model.activityShort
                        width: parent.width
                        wrapMode: Text.Wrap
                        color: "gold"
                        visible: text != ""
                    }

                    // BirthDate
                    Row {
                        width: parent.width

                        Label {
                            id: personBirthDateTitle
                            text: model.gender == "1" ? "Né le: " : "Née le: "
                            visible: model.birthDate
                            color: "gold"
                        }
                        Label {
                            id: personBirthDate
                            text: DateTools.formatDate(new Date(DateTools.getDateFromFormat(model.birthDate, "yyyy-MM-d")), "dd NNN yyyy")
                            width: parent.width - personBirthDateTitle.width
                            color: "ghostwhite"
                            elide: Text.ElideRight
                            visible: model.birthDate
                        }
                        Label {
                            id: unknownBirthDate
                            text : "Date de naissance inconnue"
                            color: "ghostwhite"
                            visible: !model.birthDate
                        }
                    }
                }
            }

            // Biography
            ListComponentExtend {
                anchors.left: parent.left
                anchors.right: parent.right
                title: "Biographie"
                shortText: model.biographyShort
                longText: model.biography
                visible: model.biographyShort || model.biography
            }

            ListComponentText {
                anchors.left: parent.left
                anchors.right: parent.right
                content: "Pas de biographie"
                visible: !model.biographyShort && !model.biography
            }

//            // completeFilmography
//            ListComponentLink {
//                anchors.left: parent.left
//                anchors.right: parent.right
//                icon: "image://theme/icon-m-content-videos-inverse"
//                text: "Filmographie"
//            }

        }
    }

    ScrollDecorator {
        flickableItem: personListView
    }
}
