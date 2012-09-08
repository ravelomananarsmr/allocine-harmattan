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
import com.nokia.extras 1.1
import "Helpers.js" as Helpers

Page {
    id: pageSearchMovies
    tools: buttonTools

    function searchMovies(text) {
        modelSearchMovies.movieQuery = text;
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: "Films"
    }

    LoadingOverlay {
        id: searchFilmsLoadingOverlay
        visible: modelSearchMovies.loading
        loadingText: "Recherche de films"
    }

    ModelSearchMovies {
        id: modelSearchMovies
        onLoadingChanged:{
            if (!loading && model.count == 0 && model.xml){
                banner.text= "Pas de film trouvé"
                banner.show()
            }
        }
        onErrorChanged: {
            if(error){
                banner.text = "Erreur réseau"
                banner.show()
            }
        }
    }

    ItemRetry{
        id: itemRetry
        visible: modelSearchMovies.error
        onClicked: modelSearchMovies.api.call()
    }

    // moviesView
    ListView {
        id: moviesListView
        anchors.top: windowTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cacheBuffer: 3000

        visible: !searchFilmsLoadingOverlay.visible && !itemRetry.visible

        model: modelSearchMovies.model

        header: Item {

            anchors.left: parent.left
            anchors.right: parent.right
            height: searchField.height + currentMovies.height + comingSoonMovies.height

            ListComponentSearchField {
                id: searchField
                onAccepted: {
                    searchMovies(text)
                }
            }

            // currentMovies
            ListComponentLink {
                id: currentMovies
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: searchField.bottom
                icon: "image://theme/icon-m-content-videos-inverse"
                text: "Tous les films à l'affiche"
                onClicked: {
                    var component = Qt.createComponent("PageCurrentFilms.qml")
                    if (component.status == Component.Ready) {
                        pageStack.push(component, {});
                    } else {
                        console.log("Error loading component:", component.errorString());
                    }
                }
            }
            // comingSoonMovies
            ListComponentLink {
                id: comingSoonMovies
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: currentMovies.bottom
                icon: "image://theme/icon-m-content-videos-inverse"
                text: "Tous les films à venir"
                onClicked: {
                    var component = Qt.createComponent("PageComingSoonFilms.qml")
                    if (component.status == Component.Ready) {
                        pageStack.push(component, {});
                    } else {
                        console.log("Error loading component:", component.errorString());
                    }
                }
            }
        }

        delegate: ListComponentMovie {
            movieActors: model.actors
            movieCode: model.code
            movieDirectors: model.directors
            movieOriginalTitle: model.originalTitle
            movieReleaseDate: model.releaseDate
            movieTitle: model.title
            moviePoster: model.poster
            movieProductionYear: model.productionYear
        }
    }

    ScrollDecorator {
        flickableItem: moviesListView
    }

    ToolBarLayout {
        id: buttonTools
        ToolIcon { iconId: "toolbar-back"; onClicked: { /*myMenu.close();*/ pageStack.pop(); }  }
    }
}
