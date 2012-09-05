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
import QtMobility.location 1.2

Item {
    property string theaterName
    property string theaterCode
    property real tlatitude: 0
    property real tlongitude: 0
    property string theaterAddress
    property string theaterCity
    property string linkWeb


    id: listItem
    height: 100
    width: parent.width

    Rectangle {
        id: background
        anchors.fill: parent
        // Fill page borders
        anchors.leftMargin: -parent.anchors.leftMargin
        anchors.rightMargin: -parent.anchors.rightMargin
        visible: mouseArea.pressed
        color: "#202020"
    }

    Row {
        anchors.fill: parent
        anchors.margins: rootWindow.pageMargin

        Column {
            anchors.verticalCenter: parent.verticalCenter

            Label {
                id: theaterNameLabel
                text: theaterName
                font.weight: Font.Bold
                font.pixelSize: 26
                width: listView.width - 30
                maximumLineCount: 1
                elide: Text.ElideRight
                color: "ghostwhite"
            }

            Coordinate {
                id: theaterCoordinate
                latitude: tlatitude
                longitude: tlongitude
                onLatitudeChanged:  {
                            theaterDistanceLabel.update()
                    console.debug("tlatitude " +tlatitude)
                }
                onLongitudeChanged: theaterDistanceLabel.update()
            }

            Label {
                id: theaterDistanceLabel
                text: ""
                font.weight: Font.Light
                font.pixelSize: 22
                width: listView.width - 30
                elide: Text.ElideRight
                color: "ghostwhite"
                visible: myPositionSource.position.coordinate.latitude && myPositionSource.position.coordinate.longitude
                function update(){
                    text="A " + Helpers.formatdistance(theaterCoordinate.distanceTo(myPositionSource.position.coordinate)) + " de moi"
                }
            }

            Label {
                id: theaterAddressLabel
                text: theaterAddress + ", "+ theaterCity
                font.weight: Font.Light
                font.pixelSize: 22
                width: listView.width - 30
                elide: Text.ElideRight
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
           enabled = false
           var component = Qt.createComponent("PageTheater.qml")
           if (component.status == Component.Ready) {
               pageStack.push(component, {
                    theaterCode: theaterCode,
                    theaterName: theaterName,
                    linkWeb: linkWeb
                });
               enabled = true
           } else {
               console.log("Error loading component:", component.errorString());
               enabled = true
            }
         }
    }
}
