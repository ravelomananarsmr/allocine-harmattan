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

Page {
    id: pageComingSoonFilms
    tools: buttonTools

    function filterMovies(text) {
        console.log("Filtering movies on " + text);
        modelComingSoonMovies.model.query = "/feed/movie[contains(lower-case(child::title),lower-case(\""+text+"\"))]";
        modelComingSoonMovies.model.reload();
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: "Films à venir"
    }

    LoadingOverlay {
        id: pageIncomingFilmsLoadingOverlay
        visible: modelComingSoonMovies.loading
        loadingText: "Recherche des films à venir"
    }

    ModelMovieList {
        id: modelComingSoonMovies
        filter: "comingsoon"
        order: "dateasc"

        onLoadingChanged:{
            if (!loading && model.count == 0){
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
        visible: modelComingSoonMovies.error
        onClicked: modelComingSoonMovies.api.call()
    }
    // moviesView
    ListView {
        id: moviesListView
        anchors.top: windowTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cacheBuffer: 3000
        visible: !pageIncomingFilmsLoadingOverlay.visible && !itemRetry.visible

        model: modelComingSoonMovies.model
        header: Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: filterField.height

            ListComponentSearchField {
                id: filterField
                placeholderText: "Filtrer"
                onAccepted: {
                    filterMovies(filterField.text)
                }
            }
        }

        delegate: ListComponentMovie {
            movieActors: model.actors
            movieCode: model.code
            movieDirectors: model.directors
            movieOriginalTitle: model.originalTitle
            movieTitle: model.title
            moviePoster: model.poster
            movieReleaseDate: model.releaseDate
            movieProductionYear: model.productionYear
        }
    }

    ScrollDecorator {
        flickableItem: moviesListView
    }

    ToolBarLayout {
        id: buttonTools
        ToolIcon { iconId: "toolbar-back"; onClicked: { /*myMenu.close();*/ pageStack.pop(); }  }
        ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
    }

    Menu {
        id: myMenu
        MenuLayout {
            MenuItem { text: "Trier par popularité";
                onClicked: {
                    modelComingSoonMovies.order = "toprank"
                }
            }
            MenuItem { text: "Trier par nombre de salles";
                onClicked: {
                    modelComingSoonMovies.order = "theatercount"
                }
            }
            MenuItem { text: "Trier les sorties les plus proches";
                onClicked: {
                    modelComingSoonMovies.order = "dateasc"
                }
            }
            MenuItem { text: "Trier les sorties les plus éloignées";
                onClicked: {
                    modelComingSoonMovies.order = "datedesc"
                }
            }
        }
    }
}
