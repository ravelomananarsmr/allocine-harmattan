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


XmlListModel {
    property string personCode
    property string source: personCode ? "http://api.allocine.fr/rest/v3/person?partner=" + partner + "&profile=large&code=" + personCode + "&format=xml   " : ""

    onSourceChanged: {
        console.log(source)
        var file = new XMLHttpRequest();
        file.onreadystatechange = function() {
            if (file.readyState == XMLHttpRequest.DONE) {
                xml = file.responseText

            }
        }
        file.open("GET", source);
        file.send();
    }

    query: "/person"
    namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"

    XmlRole { name: "givenName"; query: "name/@given/string()" }
    XmlRole { name: "realName"; query: "realName/string()" }
    XmlRole { name: "gender"; query: "gender/number()" }
    XmlRole { name: "familyName"; query: "name/@family/string()" }
    XmlRole { name: "activityShort"; query: "activityShort/string()" }
    XmlRole { name: "biographyShort"; query: "biographyShort/string()" }
    XmlRole { name: "biography"; query: "biography/string()" }
    XmlRole { name: "birthDate"; query: "birthDate/string()" }
    XmlRole { name: "birthPlace"; query: "birthPlace/string()" }
    XmlRole { name: "picture"; query: "picture/@href/string()" }
    XmlRole { name: "code"; query: "@code/string()" }

    XmlRole { name: "linkWeb"; query: "linkList/link[@rel='aco:web']/@href/string()"}

    onStatusChanged: {
        if (status == XmlListModel.Error) {
            console.log("Error: " + errorString())
            banner.show(windowTitleBar.y,"Erreur:\nImpossible de charger la personne")
        }
    }
}
