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
    id: pagePicture
    tools: buttonTools

    property string imageSource
    property string title

    ToolBarLayout {
        id: buttonTools

        ToolIcon { iconId: "toolbar-back"; onClicked: {pageStack.pop(); }  }
        ToolIcon {
            iconSource: enabled ? "image://theme/icon-m-toolbar-share-white" : "image://theme/icon-m-toolbar-share-dimmed-white"
            onClicked: {
                console.log("Sharing " + imageSource);
                shareString.title=title
                shareString.description="Image sur AlloCiné"
                shareString.mimeType="image/jpeg"
                shareString.text=imageSource
                shareString.share();
            }
            enabled: imageSource
        }
        ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
    }

    Rectangle {
        id: background
        color: "black"
        anchors.fill: parent
    }

    LoadingOverlay {
        id: pagePictureLoadingOverlay
        visible: pictureImage.status === Image.Loading
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

        Menu {
            id: myMenu
            MenuLayout {
                MenuItem { text: "Ouvrir dans le navigateur";
                    onClicked: {
                        Qt.openUrlExternally(imageSource)
                        console.log("Opening URL: " + imageSource)
                    }
                }
            }
        }
    }
}
