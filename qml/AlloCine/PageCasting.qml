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

Page {
    id: pageCasting
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
        visible: modelCasting.status == XmlListModel.Loading
        loadingText: "Chargement du casting"
    }

    ModelCasting {
        id: modelCasting
    }

    ListView {
        id: castingListView
        anchors.top: parent.top
        anchors.topMargin: windowTitleBar.height
        anchors.fill: parent
        Component.onCompleted: modelCasting.mCode = mCode
        model: modelCasting

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
                    width: pageCasting.width - posterImageContainer.width - arrow.width - 20

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