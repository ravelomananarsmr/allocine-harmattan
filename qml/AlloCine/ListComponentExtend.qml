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
    property string shortText
    property string longText
    property string title

    property int separation: pageMargin
    height: titleLabel.height + textItem.height + extender.height

    signal clicked()

    Label {
        id: titleLabel
        text: title
        color: "ghostwhite"
        font.weight: Font.Bold
    }

    Item {
        id: textItem
        anchors.top: titleLabel.bottom
        width: parent.width

        Text {
            id: shortTextLabel
            text: shortText
            width: parent.width
            color: "ghostwhite"
            wrapMode: Text.Wrap
            horizontalAlignment:  Text.AlignJustify
            font.pointSize: titleLabel.font.pointSize
            visible: true
        }

        Text {
            id: longTextLabel
            text: longText
            width: parent.width
            color: "ghostwhite"
            wrapMode: Text.Wrap
            horizontalAlignment:  Text.AlignJustify
            font.pointSize: titleLabel.font.pointSize
            visible: false
            clip: true
        }
    }

    state: "SYNOPSYS_RETRACTED"

    states: [
        State {
             name: "SYNOPSYS_RETRACTED"
             PropertyChanges { target: shortTextLabel; visible: true }
             PropertyChanges { target: longTextLabel; visible: false }
             PropertyChanges { target: textItem; height: shortTextLabel.height }
             PropertyChanges { target: longTextLabel; height: textItem.height } // Hack to not have overlap between longtext and items below
         },

        State {
             name: "SYNOPSYS_EXTENDED"
             PropertyChanges { target: shortTextLabel; visible: false }
             PropertyChanges { target: longTextLabel; visible: true }
             PropertyChanges { target: textItem; height: longTextLabel.height }
             PropertyChanges { target: longTextLabel; height: longTextLabel.paintedHeight } // Hack to not have overlap between longtext and items below
         }
    ]

    transitions: [
        Transition {
            from: "SYNOPSYS_RETRACTED"
            to: "SYNOPSYS_EXTENDED"
            NumberAnimation { target: textItem; property: "height"; duration: extender.animationDuration; easing.type: Easing.InOutQuad }
            NumberAnimation { target: longTextLabel; property: "height"; duration: extender.animationDuration; easing.type: Easing.InOutQuad }
        },
        Transition {
            from: "SYNOPSYS_EXTENDED"
            to: "SYNOPSYS_RETRACTED"
            NumberAnimation { target: textItem; property: "height"; duration: extender.animationDuration; easing.type: Easing.InOutQuad }
            NumberAnimation { target: longTextLabel; property: "height"; duration: extender.animationDuration; easing.type: Easing.InOutQuad }
        }
    ]

    ItemExtender {
        id: extender
        anchors.top: textItem.bottom
        onClicked: {
            if (state == "RETRACTED") {
                myItem.state = "SYNOPSYS_RETRACTED"
            } else if (state == "EXTENDED") {
                myItem.state = "SYNOPSYS_EXTENDED"
            }
        }
        visible: (shortText != longText)
    }

    Component.onCompleted: {
        mouseArea.clicked.connect(clicked)
    }
}
