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

Item {
    id: myItem
    property string icon
    property string text
    property int separation: pageMargin
    property int minimumHeight: 64

    height: Math.max(iconImage.height, labelText.height, minimumHeight) + 16

    signal clicked()

    Rectangle {
        id: background
        anchors.fill: parent
        visible: mouseArea.pressed
        color: colorSelectedListItem
    }

    Image {
        id: iconImage
        source: icon
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: pageMargin
    }
    Label {
        id: labelText
        anchors.left: iconImage.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: separation
        wrapMode: Text.Wrap
        width: parent.width - arrow.width - iconImage.width
        text: myItem.text
    }
    Image {
        id: arrow
        source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
        anchors.right: parent.right;
        anchors.verticalCenter: parent.verticalCenter
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }

    Component.onCompleted: {
        mouseArea.clicked.connect(clicked)
    }
}
