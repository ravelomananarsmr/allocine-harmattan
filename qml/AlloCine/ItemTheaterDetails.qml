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
import QtMobility.location 1.2
import "Helpers.js" as Helpers

Item {
    property bool showMap: true
    property string theaterAddress
    property real theaterLatitude
    property real theaterLongitude
    property string theaterPostalCode
    property string theaterCity
    property string theaterCinemaChain
    property string theaterScreenCount

    height: theaterDetails.height

    Coordinate {
        id: theaterCoordinate
        latitude: theaterLatitude
        longitude: theaterLongitude
        onLatitudeChanged: distanceLabel.update()
        onLongitudeChanged: distanceLabel.update()
    }

    Row {
        id: theaterDetails
        height: theaterDetailsText.height

        // map
        Map {
            id: map
            visible: showMap
            plugin : Plugin {name : "nokia"}
            size.height: theaterDetailsText.height
            size.width: theaterDetailsText.height
            zoomLevel: 15
            center: theaterCoordinate

            MapImage {
                id: theaterMarker
                offset.x: -71/2
                offset.y: -71
                source: "qrc:///images/pinpoint-theater"
                coordinate: theaterCoordinate
            }

            MapImage {
                id: meMarker
                offset.x: -71/2
                offset.y: -71
                source: "qrc:///images/pinpoint-me"
                coordinate: myPositionSource.position.coordinate
            }

            MouseArea {
                id: mapMouseArea
                anchors.fill: parent
                onPressed: {
                    var component = Qt.createComponent("PageTheatersMap.qml")
                    if (component.status == Component.Ready) {
                        console.log("Opening Map centered on lat=" + theaterCoordinate.latitude + " and long = " + theaterCoordinate.longitude);
                        pageStack.push(component, {
                             searchAroundMe: false,
                             centerCoordinate: theaterCoordinate,
                             theaterCoordinate: theaterCoordinate
                         });
                    } else {
                        console.log("Error loading component:", component.errorString());
                     }
                }
            }
        }

        Column {
            id: theaterDetailsText

            Label {
                id: theaterAddressLabel
                text: theaterAddress
                color: "ghostwhite"
            }
            Label {
                id: cityLabel
                text: theaterPostalCode + " " + theaterCity
                color: "ghostwhite"
            }
            Label {
                id: distanceLabel
                text: ""
                color: "gold"
                visible: myPositionSource.position.coordinate.latitude && myPositionSource.position.coordinate.longitude
                function update(){
                    text=(myPositionSource.position.coordinate.latitude!==0 && myPositionSource.position.coordinate.longitude!==0) ? Helpers.formatdistance(theaterCoordinate.distanceTo(myPositionSource.position.coordinate)) + " de moi" : "Calcul de la distance..."
                }
            }

            Label {
                text: "Type: " + theaterCinemaChain
                color: "ghostwhite"
            }
            Label {
                text: "Ecrans: " + theaterScreenCount
                color: "ghostwhite"
            }
        }
    }
}
