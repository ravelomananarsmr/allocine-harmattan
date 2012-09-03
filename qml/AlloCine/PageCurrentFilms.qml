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
    id: pageCurrentFilms
    tools: buttonTools

    function filterMovies(text) {
        console.log("Filtering movies on " + text);
        modelCurrentMovies.query = "/feed/movie[contains(lower-case(child::title),lower-case(\""+text+"\"))]";
        modelCurrentMovies.reload();
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: "Films à l'affiche"
    }

    LoadingOverlay {
        id: pageCurrentFilmsLoadingOverlay
        visible: !(modelCurrentMovies.status == XmlListModel.Ready)
        loadingText: "Recherche des films à l'affiche"
    }

    ModelMovieList {
        id: modelCurrentMovies
        filter: "nowshowing"
    }

    // moviesView
    ListView {
        id: moviesListView
        anchors.top: windowTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cacheBuffer: 3000
        visible: !pageCurrentFilmsLoadingOverlay.visible

        model: modelCurrentMovies
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
                    modelCurrentMovies.order = "toprank"
                }
            }
            MenuItem { text: "Trier par nombre de salles";
                onClicked: {
                    modelCurrentMovies.order = "theatercount"
                }
            }
            MenuItem { text: "Trier par date de sortie";
                onClicked: {
                    modelCurrentMovies.order = "dateasc"
                }
            }
            MenuItem { text: "Trier par nouveauté";
                onClicked: {
                    modelCurrentMovies.order = "datedesc"
                }
            }
        }
    }
}
