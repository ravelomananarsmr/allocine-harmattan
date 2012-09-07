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

MapImage {

    id: itemTheaterMap

    property variant theaterCode
    property variant theaterName

    source: "qrc:///images/pinpoint-theater"
    coordinate: Coordinate{}
    /*!
         * We want that bottom middle edge of icon points to the location, so using offset parameter
         * to change the on-screen position from coordinate. Values are calculated based on icon size,
         * in our case icon is 48x48.
         */
    offset.x: -34
    offset.y: -69
    visible:true

    MapMouseArea {
        anchors.fill: parent
        onClicked: {
            enabled = false
            var component = Qt.createComponent("PageTheater.qml")
            if (component.status == Component.Ready) {
                myPositionSource.stop()

                pageStack.push(component, {
                     theaterCode: theaterCode,
                     theaterName: theaterName
                 });
                enabled = true
            } else {
                console.log("Error loading component:", component.errorString());
                enabled = true
             }
        }
    }

}
