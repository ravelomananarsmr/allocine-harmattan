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
    property date showDate
    property string searchLat
    property string searchLong
    property string searchRadius: "10"
    property string mCode
    property string searchZip
    property string searchLocation

    property string showTimeQuery
    property string source: showTimeQuery ? "http://api.allocine.fr/rest/v3/showtimelist?partner="+partner+"&format=xml&"+showTimeQuery+"&movie="+mCode : ""

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


    onStatusChanged: {
        if (status == XmlListModel.Error) {
            banner.show(windowTitleBar.y,"Erreur:\nImpossible de charger la liste des séances")
        }
    }

    onSearchLatChanged: {
        if (searchLat && searchLong)
            showTimeQuery = "lat="+searchLat+"&long="+searchLong+"&radius="+searchRadius
    }
    onSearchLongChanged: {
        if (searchLat && searchLong)
            showTimeQuery = "lat="+searchLat+"&long="+searchLong+"&radius="+searchRadius
    }
    onTheaterCodeChanged: {
        if (theaterCode)
            showTimeQuery = "theaters=" + theaterCode
    }
    onSearchZipChanged: {
        if (searchZip)
            showTimeQuery = "zip=" + searchZip
    }
    onSearchLocationChanged: {
        if (searchLocation)
            showTimeQuery = "location=" + searchLocation
    }
}
