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
    id: pageSearchPersons
    tools: buttonTools

    function searchPersons(text) {
        modelSearchPersons.personQuery = text;
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: "Personnes"
    }

    LoadingOverlay {
        id: searchPersonsLoadingOverlay
        visible: modelSearchPersons.loading
    }

    ModelSearchPersons {
        id: modelSearchPersons
        onStatusChanged: {
            if (status == XmlListModel.Ready){
                if (count == 0 && xml){
                    banner.text= "Pas de profil trouvé"
                    banner.show()
                }
            }
        }
        onErrorChanged: {
            if(error){
                banner.text = "Erreur réseau"
                banner.show()
            }
        }
    }

    // personsView
    ListView {
        id: personsListView
        anchors.top: windowTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        //anchors.topMargin: 16
        cacheBuffer: 3000

        visible: !searchPersonsLoadingOverlay.visible && !itemRetry.visible

        model: modelSearchPersons

        header: ListComponentSearchField {
            id: searchField
            onAccepted: {
                searchPersons(text)
            }
        }

        delegate: ListComponentPerson {
            personBirthDate: model.birthDate
            personCode: model.code
            personGender: model.gender
            personName: model.name
            personPicture: model.picture
        }
    }

    ItemRetry{
        id: itemRetry
        visible: modelSearchPersons.error || modelSearchPersons.status=== XmlListModel.Error
        onClicked: modelSearchPersons.callAPI()
    }

    ScrollDecorator {
        flickableItem: personsListView
    }

    ToolBarLayout {
        id: buttonTools
        ToolIcon { iconId: "toolbar-back"; onClicked: { /*myMenu.close();*/ pageStack.pop(); }  }
        //ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
    }


//    Menu {
//        id: myMenu

//        MenuLayout {
//            MenuItem { text: "Test"; }
//        }
//    }
}
