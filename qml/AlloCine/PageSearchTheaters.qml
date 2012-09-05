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

Page {
    id: pageSearchTheaters
    tools: buttonTools

    property bool positionRequested: false

    // buttonTools
    ToolBarLayout {
        id: buttonTools

        ToolIcon { iconId: "toolbar-back"; onClicked: { myMenu.close(); pageStack.pop(); }  }
        ToolButtonRow {
            ToolButton {
                id: aroundMeButton
                text: "Autour de moi";
                onClicked: {
                    positionRequested = true
                    if (!myPositionSource.position.coordinate.latitude || !myPositionSource.position.coordinate.longitude){
                        myPositionSource.start()
                    } else {
                        modelSearchTheaters.searchLat = ""
                        modelSearchTheaters.searchLong = ""
                        modelSearchTheaters.searchLat = myPositionSource.position.coordinate.latitude
                        modelSearchTheaters.searchLong = myPositionSource.position.coordinate.longitude
                    }
                }
            }
        }
        ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: "Salles"
        busy: !theatersPageLocateMeLoadingOverlay && (!myPositionSource.position.coordinate.latitude || !myPositionSource.position.coordinate.longitude)
    }

    LoadingOverlay {
        id: theatersPageSearchTheaterLoadingOverlay
        loadingText: "Recherche de salles"
        visible: modelSearchTheaters.status == XmlListModel.Loading
    }

    LoadingOverlay {
        id: theatersPageLocateMeLoadingOverlay
        loadingText: "Recherche de ma position"
        visible: (myPositionSource.active && positionRequested)
    }

    ModelSearchTheaters {
        id: modelSearchTheaters

        searchLat: (myPositionSource.position.coordinate.latitude && positionRequested) ? myPositionSource.position.coordinate.latitude : ""
        searchLong: (myPositionSource.position.coordinate.longitude && positionRequested) ? myPositionSource.position.coordinate.longitude : ""
    }

    // theaterListView
    ListView {
        id: theaterListView
        anchors.top: windowTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        model: modelSearchTheaters
        visible: (!theatersPageLocateMeLoadingOverlay.visible && !theatersPageSearchTheaterLoadingOverlay.visible)
        header: ListComponentSearchField {
            id: searchField
            placeholderText: "Ville ou code postal"
            onAccepted: {
                console.log("Location searched: " + text)
                if((parseFloat(text) == parseInt(text)) && !isNaN(text)){
                    modelSearchTheaters.searchZip = text
                } else {
                    modelSearchTheaters.searchLocation = text
                }
            }
        }
        delegate: ListComponentTheater {
            theaterName: model.name
            theaterCode: model.code
            tlatitude: model.tlatitude
            tlongitude: model.tlongitude
            theaterAddress: model.address
            theaterCity: model.city
            linkWeb: model.linkWeb
        }
    }

    ScrollDecorator {
        flickableItem: theaterListView
    }

    Menu {
        id: myMenu

        MenuLayout {
            MenuItem { text: "Voir la carte autour de moi";
                       onClicked: {
                    var component = Qt.createComponent("PageTheatersMap.qml")
                    if (component.status == Component.Ready) {
                        console.log("Opening Map centered on lat=" + myPositionSource.position.coordinate.latitude + " and long = " + myPositionSource.position.coordinate.longitude);
                        pageStack.push(component);
                    } else {
                        console.log("Error loading component:", component.errorString());
                     }
                  }
            }
            MenuItem { text: "Rayon: 1 km";
                onClicked: {
                    modelSearchTheaters.searchRadius = 1
                }
            }
            MenuItem { text: "Rayon: 10 km";
                onClicked: {
                    modelSearchTheaters.searchRadius = 10
                }
            }
            MenuItem { text: "Rayon: 100 km";
                onClicked: {
                    modelSearchTheaters.searchRadius = 100
                }
            }
        }
    }
}
