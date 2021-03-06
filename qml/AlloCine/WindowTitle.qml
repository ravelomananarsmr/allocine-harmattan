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
    id: windowTitleBar
    anchors.left: parent.left
    anchors.right: parent.right
    height: windowTitleHeight
    z: 1000
    property string windowTitle: "AlloCine"
    property string windowTitleBackup: "AlloCine"
    property bool busy: false

    Rectangle {
        id: windowTitleRectangle
        color: "gold"
        anchors.fill: parent
        z:1
    }

    Label {
        id: windowTitleTextLabel
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        text: windowTitle
        font.weight: Font.Light
        font.pointSize: fontSizeMedium
        color: "white"
        width: parent.width - 2*anchors.leftMargin
        elide: Text.ElideRight
        visible: windowTitle != ""
        z:2
    }

    Label {
        id: windowTitleBackupTextLabel
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        text: windowTitleBackup
        font.weight: Font.Light
        font.pixelSize: fontSizeLarge
        color: "white"
        width: parent.width - 2*anchors.leftMargin
        elide: Text.ElideRight
        visible: windowTitle == ""
        z:2
    }

    Rectangle {
        anchors.right: parent.right
        height: parent.height
        width: parent.height
        color: "gold"
        visible: busy
        z:3

        BusyIndicator {
            z:4
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            running: true
            platformStyle: BusyIndicatorStyle { size: "medium" }
        }
    }
}
