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

Item {
    property bool loading: api.loading || model.status === XmlListModel.Loading
    property bool error: api.error || model.error === XmlListModel.Error

    property alias api: api
    property alias model: model

    property string mCode

    //onLoadingChanged: console.debug("ModelMovie loading=" + loading)
    //onErrorChanged: console.debug("ModelMovie error=" + loading)

    APICaller {
        id: api
        source: mCode ? "http://api.allocine.fr/rest/v3/movie?partner="+partner+"&q=61282&format=xml&code="+mCode : ""
        onResponseTextChanged: model.xml=responseText
    }

    XmlListModel {
        id: model
        onStatusChanged: {
            if (status == XmlListModel.Error)
                console.debug("XmlListModel.Ready")
            if (status == XmlListModel.Null)
                console.debug("XmlListModel.Null")
            if (status == XmlListModel.Loading)
                console.debug("XmlListModel.Loading")
            if (status == XmlListModel.Ready)
                console.debug("XmlListModel.Ready count=" + count + " source=" + api.source)
        }

        query: "/movie/casting/castMember"
        namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"

        XmlRole { name: "personCode"; query: 'person/@code/string()' }
        XmlRole { name: "name"; query: 'person/name/string()' }
        XmlRole { name: "activity"; query: 'activity/string()' }
        XmlRole { name: "picture"; query: 'picture/@href/string()' }
        XmlRole { name: "role"; query: 'role/string()' }
    }
}
