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
    id: myComponentSearchField
    property string placeholderText: "Recherche"
    property string text: myComponentSearchFieldTextField.text

    signal accepted()
    signal textChanged()

    height: 80

    anchors.topMargin: 10
    anchors.bottomMargin: 10

    anchors.leftMargin: 16
    anchors.rightMargin: 16

    anchors.left: parent.left
    anchors.right: parent.right

    TextField {
        id: myComponentSearchFieldTextField
        //anchors.fill: parent
        height: 50
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right

        placeholderText: myComponentSearchField.placeholderText

        Image {
            anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: 16 }
            id: clearText
            fillMode: Image.PreserveAspectFit
            smooth: true;
            source: "image://theme/icon-m-toolbar-search"
            height: parent.height - platformStyle.paddingMedium * 2
            width: parent.height - platformStyle.paddingMedium * 2

            MouseArea {
                id: myComponentSearchFieldMouseArea
                anchors.fill: parent
            }
        }

        Component.onCompleted: {
            myComponentSearchFieldMouseArea.clicked.connect(myComponentSearchField.accepted)
            myComponentSearchFieldTextField.accepted.connect(myComponentSearchField.accepted)
            myComponentSearchFieldTextField.textChanged.connect(myComponentSearchField.textChanged)
        }
    }
}
