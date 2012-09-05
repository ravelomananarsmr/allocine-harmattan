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
    property string theaterCode
    property date showDate // Not Implemented

    function performTheaterMoviesQuery(){
        console.log("Calling API to update ModelTheaterMovies: " + "http://api.allocine.fr/rest/v3/showtimelist?partner="+partner+"&q=61282&format=xml&theaters="+theaterCode)
        var showtimelistFile = new XMLHttpRequest();
        showtimelistFile.onreadystatechange = function() {
            if (showtimelistFile.readyState == XMLHttpRequest.DONE) {
                xml = showtimelistFile.responseText

            }
        }
        showtimelistFile.open("GET", "http://api.allocine.fr/rest/v3/showtimelist?partner="+partner+"&q=61282&format=xml&theaters="+theaterCode);
        showtimelistFile.send();
    }

    query: "//feed/theaterShowtimes[place/theater/@code/string()=\""+theaterCode+"\"]/movieShowtimesList/movieShowtimes"

    namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"
    XmlRole { name: "title"; query: 'onShow/movie/title/string()' }
    XmlRole { name: "mCode"; query: 'onShow/movie/@code/string()' }
    XmlRole { name: "poster"; query: "onShow/movie/poster/@href/string()" }
    XmlRole { name: "releaseDate"; query: "onShow/movie/release/releaseDate/string()" }
    XmlRole { name: "version"; query: "version/string()" }
    XmlRole { name: "screenFormat"; query: "screenFormat/string()" }
    XmlRole { name: "runtime"; query: "onShow/movie/runtime/number()" }
    XmlRole { name: "directors"; query: "onShow/movie/castingShort/directors/string()" }
    XmlRole { name: "actors"; query: "onShow/movie/castingShort/actors/string()" }
    XmlRole { name: "screenFormatCode"; query: "screenFormat/@code/string()" }
    XmlRole { name: "versionCode"; query: "version/@code/string()" }

}