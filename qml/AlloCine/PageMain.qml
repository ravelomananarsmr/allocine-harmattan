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
    id: pageMain
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
            page: "PageSearchTheaters.qml"
            title: "Salles"
            subtitle: "Rechercher une salle de cinéma"
        }
        ListElement {
            page: "PageSearchMovies.qml"
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

         header: Image {
             id: allocineLogo
            width: pageMain.width * 0.9
            smooth: true
            fillMode: Image.PreserveAspectFit
            source: "qrc:///images/main-logo"
        }

        delegate:  Item {
            id: listItem
            height: 88
            width: parent.width

            Rectangle {
                id: background
                anchors.fill: parent
                // Fill page borders
                anchors.leftMargin: -pageMain.anchors.leftMargin
                anchors.rightMargin: -pageMain.anchors.rightMargin
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
                    pageMain.openFile(page)
                }
            }
        }
    }
}
