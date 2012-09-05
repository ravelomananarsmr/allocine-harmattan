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

    property string searchLat
    property string searchLong
    property string searchCode
    property string searchZip
    property string searchLocation
    property int searchRadius: 10
    property string source: searchQuery ? "http://api.allocine.fr/rest/v3/theaterlist?partner="+partner+"&count=200&page=1&format=xml&"+searchQuery+"&radius="+searchRadius : ""
    property string searchQuery

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

    query: searchCode ? "/feed/theater[@code=\""+ searchCode + "\"]" : "/feed/theater"
    namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"

    XmlRole { name: "name"; query: "name/string()" }
    XmlRole { name: "address"; query: "address/string()" }
    XmlRole { name: "city"; query: "city/string()" }
    XmlRole { name: "postalCode"; query: "postalCode/string()" }
    XmlRole { name: "cinemaChain"; query: "cinemaChain/string()" }
    XmlRole { name: "screenCount"; query: "screenCount/string()" }
    XmlRole { name: "tlatitude"; query: "geoloc/@lat/number()" }
    XmlRole { name: "tlongitude"; query: "geoloc/@long/number()" }
    XmlRole { name: "code"; query: "@code/string()" }

    onSearchLatChanged: {
        if (searchLat && searchLong)
            searchQuery = "lat="+searchLat+"&long="+searchLong
    }
    onSearchLongChanged: {
        if (searchLat && searchLong)
            searchQuery = "lat="+searchLat+"&long="+searchLong
    }
    onSearchCodeChanged: {
        searchQuery = "theater="+searchCode
    }
    onSearchLocationChanged: {
        searchQuery = "location="+searchLocation
    }
    onSearchZipChanged: {
        searchQuery = "zip="+searchZip
    }
}
