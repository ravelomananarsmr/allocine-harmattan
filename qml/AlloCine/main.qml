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
import QtMobility.location 1.2
import com.nokia.extras 1.1


PageStackWindow {
    id: rootWindow
    property int pageMargin: 16
    property string partner: "YW5kcm9pZC12M3M"
    property string mobileVideoUrl: "http://m.allocine.fr/movie/viewvideo?codevideo="

    property string colorSelectedListItem: "#202020"

    property int positionSourceContinuousRequestors: 0
    property bool initialPositionFix: true

    Label {
        id: dummyLabel
    }

    property int fontSizeLarge: fontSizeSmall * 1.5
    property int fontSizeMedium: fontSizeSmall * 1.25
    property int fontSizeSmall: dummyLabel.font.pointSize
    property int windowTitleHeight: 70

    InfoBanner{
        id:banner
        y:windowTitleHeight
    }
    showStatusBar: rootWindow.inPortrait

    Component.onCompleted: theme.inverted = true

    platformStyle: PageStackWindowStyle {
        background: 'qrc:///images/background'
        backgroundFillMode: Image.Stretch
    }

    // ListPage is shown when the application starts, it links to
    // the component specific pages
    initialPage: PageMain { }

    // These tools are shared by most sub-pages by assigning the
    // id to a tools property of a page
    ToolBarLayout {
        id: commonTools
        visible: false
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: { myMenu.close(); pageStack.pop(); }
        }
        ToolIcon {
            iconId: "toolbar-view-menu";
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    //screeningDateModel


    //screeningTimeModel
    Component{
        id: screeningTimeModel
        XmlListModel {
            property string theaterCode
            property string movieCode
            property string screeningDate
            property string versionCode
            property string screenFormatCode
            query: "//feed/theaterShowtimes[place/theater/@code/string()=\""+theaterCode+"\"]/movieShowtimesList/movieShowtimes[onShow/movie/@code/string()='"+movieCode+"' and version/@code/string()='"+versionCode+"' and screenFormat/@code/string()='"+screenFormatCode+"']/screenings/scr[@d=\""+screeningDate+"\"]/t"
            namespaceDeclarations: "declare default element namespace 'http://www.allocine.net/v6/ns/';"
            XmlRole { name: "time"; query: 'string()' }
            Component.onCompleted:
            {
                if(screenFormatCode=="")
                    query="//feed/theaterShowtimes[place/theater/@code/string()=\""+theaterCode+"\"]/movieShowtimesList/movieShowtimes[onShow/movie/@code/string()='"+movieCode+"' and version/@code/string()='"+versionCode+"' ]/screenings/scr[@d=\""+screeningDate+"\"]/t"
                console.debug("theaterCode="+theaterCode+" movieCode="+movieCode+ " versionCode="+versionCode+ " screenFormatCode="+screenFormatCode)
            }
        }
    }

    //myPosition
    PositionSource{
        id: myPositionSource
        updateInterval: 2000
        active: true
        onActiveChanged: {
            if (!initialPositionFix){
                if (active) {
                    positionSourceContinuousRequestors++
                } else {
                     positionSourceContinuousRequestors--
                }
            }
            console.log("myPosition active: " + active + " " + positionSourceContinuousRequestors + " requestors")
        }
        onPositionChanged: {
            if (positionSourceContinuousRequestors == 0){
                stop()
            }
            initialPositionFix = false
            console.log("myPosition updated: " + position.coordinate.latitude + " - " + position.coordinate.longitude + " " + positionSourceContinuousRequestors + " requestors")
        }
    }
}
