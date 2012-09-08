/*************************************************************************************
                AlloCine application for Harmattan
         This application is released under BSD-2 license
                   -------------------------

Copyright (c) 2012, Antoine Vacher, Sahobimaholy Ravelomanana
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation and/or
    other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*************************************************************************************/

import QtQuick 1.1
import com.nokia.meego 1.1
import "Helpers.js" as Helpers
import "DateTools.js" as DateTools

Page {
    id: pagePerson
    tools: buttonTools

    property int personCode
    property string name
    property string personLinkWeb

    WindowTitle {
        id: windowTitleBar
        windowTitle: name
        windowTitleBackup: "Illustre Inconnu"
    }

    LoadingOverlay {
        id: pagePersonLoadingOverlay
        loadingText: "Chargement du profil"
        visible: modelPerson.loading || !posterImage.status == Image.Ready
    }

    ModelPerson {
        id: modelPerson
        personCode: pagePerson.personCode
        onErrorChanged: {
            if(error){
                banner.text = "Erreur réseau"
                banner.show()
            }
        }
    }

    ModelNationality {
        id: modelNationality
        xml: (!modelPerson.api.loading) ? modelPerson.api.responseText : ""

    }


    ListView {
        id: personListView
        anchors.top: parent.top
        anchors.topMargin: windowTitleBar.height
        anchors.margins: pageMargin
        anchors.fill: parent
        model: modelPerson.model
        visible: !pagePersonLoadingOverlay.visible && !itemRetry.visible

        delegate: Column {
            width: parent.width
            spacing: pageMargin

            Component.onCompleted: personLinkWeb = model.linkWeb

            Item {
                width: parent.width
                height: Math.max(itemPoster.height, mainDetails.height)

                // poster
                ItemPoster {
                    id:itemPoster
                    url: model.picture

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        enabled: model.picture
                        onClicked: {
                            var component = Qt.createComponent("PagePicture.qml")
                            if (component.status == Component.Ready) {
                                pageStack.push(component, {imageSource: model.picture? model.picture: "qrc:///images/empty", title: model.name});
                            } else {
                                console.log("Error loading component:", component.errorString());
                            }
                        }
                    }
                }
                // mainDetails
                Column{
                    id: mainDetails
                    anchors.left: itemPoster.right
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
                        id: personRealName
                        text: "(" + model.realName + ")"
                        width: parent.width
                        wrapMode: Text.Wrap
                        color: "ghostwhite"
                        visible: model.realName
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
                            text: (DateTools.formatDate(new Date(DateTools.getDateFromFormat(model.birthDate, "yyyy-MM-d")), "dd NNN yyyy")) + (model.birthPlace ? " à " + model.birthPlace : "")
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

            // nationality
            Item {
                height: nationalityLabelTitle.height + nationalityRow.height
                width: parent.width
                visible: modelNationality.count > 0

                Label {
                    id: nationalityLabelTitle
                    text: "Pays"
                    color: "ghostwhite"
                    font.weight: Font.Bold
                }

                Row {
                    id: nationalityRow
                    anchors.top: nationalityLabelTitle.bottom
                    Repeater{
                        id:nationalityRepeater
                        width: parent.width
                        model: modelNationality
                        Row {
                            Label {
                                id: nationalityLabel
                                text: model.nationality
                                elide: Text.ElideRight
                                color: "ghostwhite"
                            }
                            Label {
                                text: ", "
                                elide: Text.ElideRight
                                color: "ghostwhite"
                                visible: (index + 1 != nationalityRepeater.count)
                            }
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

            // completeFilmography
            ListComponentLink {
                anchors.left: parent.left
                anchors.right: parent.right
                icon: "image://theme/icon-m-content-videos-inverse"
                text: "Filmographie"
                onClicked: {
                    var component = Qt.createComponent("PageFilmography.qml")
                    if (component.status == Component.Ready) {
                        pageStack.push(component, {code: model.code, name: model.givenName + " " + model.familyName});
                    } else {
                        console.log("Error loading component:", component.errorString());
                    }
                }
            }

        }
    }

    ScrollDecorator {
        flickableItem: personListView
    }

    ItemRetry{
        id: itemRetry
        visible: modelPerson.error
        onClicked: modelPerson.api.call()
    }

    Menu {
        id: myMenu
        MenuLayout {
            MenuItem { text: "Ouvrir dans le navigateur";
                onClicked: {
                    Qt.openUrlExternally(personLinkWeb)
                    console.log("Opening URL: " + personLinkWeb)
                }
            }
        }
    }

    ToolBarLayout {
        id: buttonTools

        ToolIcon { iconId: "toolbar-back"; onClicked: {pageStack.pop(); }  }
        ToolIcon {
            iconSource: enabled ? "image://theme/icon-m-toolbar-share-white" : "image://theme/icon-m-toolbar-share-dimmed-white"
            onClicked: {
                console.log("Sharing " + personLinkWeb);
                shareString.title=name
                shareString.description="Profil sur AlloCiné"
                shareString.mimeType="text/x-url"
                shareString.text=personLinkWeb
                shareString.share();
            }
            enabled: personLinkWeb
        }
        ToolIcon { iconSource: enabled ? "image://theme/icon-m-toolbar-view-menu-white" : "image://theme/icon-m-toolbar-view-menu-dimmed" ; onClicked: myMenu.open(); enabled: personLinkWeb}    }

}
