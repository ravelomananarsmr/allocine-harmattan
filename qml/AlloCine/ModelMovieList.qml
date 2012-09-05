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
    id:root
    property string filter: "nowshowing"
    property string order: "datedesc"
    property bool loading:false
    property bool error:false
    function callAPI(){
        error=false
        console.log(source)
        var file = new XMLHttpRequest();
        file.onreadystatechange = function() {
            if (file.readyState === XMLHttpRequest.DONE) {
                if(file.status === 200)
                    root.xml = file.responseText
                else
                {
                    root.error=true;
                    root.loading=false
                }
                console.debug(file.status)
                console.debug("XMLHttpRequest.DONE")
            }
            if (file.readyState === XMLHttpRequest.LOADING) {
                root.loading=true
                console.debug("XMLHttpRequest.LOADING")
            }
            if (file.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                root.loading=true
                console.debug("XMLHttpRequest.HEADERS_RECEIVED")
            }
            if (file.readyState === XMLHttpRequest.UNSENT) {
                root.loading=true
                console.debug("XMLHttpRequest.UNSENT")
            }
            if (file.readyState === XMLHttpRequest.OPENED) {
                root.loading=true
                console.debug("XMLHttpRequest.OPENED")
            }
            console.debug(file.readyState)


        }
        file.open("GET", source);
        file.send();
    }
    onSourceChanged: {
        console.log(source)
        callAPI()
    }
    onStatusChanged: {
        if (status == XmlListModel.Error || status == XmlListModel.Ready)
        {
            loading=false
            console.debug("XmlListModel.Ready")
            console.debug(status)
        }
    }
    source: "http://api.allocine.fr/rest/v3/movielist?partner="+partner+"&count=100&filter="+filter+"&page=1&order="+order+"&format=xml&profile=small"
    query: "/feed/movie"
    namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"

    XmlRole { name: "movieType"; query: "movieType/string()" }
    XmlRole { name: "originalTitle"; query: "originalTitle/string()" }
    XmlRole { name: "title"; query: "title/string()" }
    XmlRole { name: "productionYear"; query: "productionYear/string()" }
    XmlRole { name: "releaseDate"; query: "release/releaseDate/string()" }
    XmlRole { name: "runtime"; query: "runtime/number()" }
    XmlRole { name: "synopsisShort"; query: "synopsisShort/string()" }
    XmlRole { name: "synopsis"; query: "synopsis/string()" }
    XmlRole { name: "poster"; query: "poster/@href/string()" }
    XmlRole { name: "directors"; query: "castingShort/directors/string()" }
    XmlRole { name: "actors"; query: "castingShort/actors/string()" }
    XmlRole { name: "code"; query: "@code/string()" }


}
