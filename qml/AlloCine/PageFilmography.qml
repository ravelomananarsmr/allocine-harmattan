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

Page {
    id: pageFilmography
    tools: buttonTools

    property string name
    property string code

    ToolBarLayout {
        id: buttonTools
        ToolIcon { iconId: "toolbar-back"; onClicked: {pageStack.pop(); }  }
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: "Filmographie de " + name
    }

    LoadingOverlay {
        id: castingOverlay
        visible: modelFilmography.loading
        loadingText: "Chargement de la filmographie"
    }

    ModelFilmography {
        id: modelFilmography
        personCode: code
        onErrorChanged: {
            if(error){
                banner.text = "Erreur réseau"
                banner.show()
            }
        }
    }

    ItemRetry{
        id: itemRetry
        visible: modelFilmography.error || modelFilmography.status=== XmlListModel.Error
        onClicked: modelFilmography.callAPI()
    }

    ListView {
        id: filmographyListView
        anchors.top: windowTitleBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        model: modelFilmography
        visible: !castingOverlay.visible && !itemRetry.visible
        delegate: ListComponentMovieParticipation {
            movieCode: model.movieCode
            movieOriginalTitle: model.movieOriginalTitle
            movieTitle: model.movieTitle
            moviePoster: model.moviePoster
            movieReleaseDate: model.movieReleaseDate
            movieReleaseState: model.movieReleaseState
            movieReleaseStateCode: model.movieReleaseStateCode
            movieProductionYear: model.movieProductionYear
            activity: model.activity
        }
    }

    ScrollDecorator {
        flickableItem: filmographyListView
    }

}
