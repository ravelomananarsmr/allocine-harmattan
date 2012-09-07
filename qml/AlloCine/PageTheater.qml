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
import "DateTools.js" as DateTools
import "Helpers.js" as Helpers

Page {
    id: pageTheater
    tools: buttonTools

    property string theaterCode
    property date showDate
    property string linkWeb

    property real theaterLatitude: 0
    property real theaterLongitude: 0
    property string theaterName
    property string theaterAddress
    property string theaterPostalCode
    property string theaterCity
    property string theaterCinemaChain
    property string theaterScreenCount

    ModelSearchTheaters {
        id: modelSearchTheaters
        searchCode:  theaterCode

        onStatusChanged: {
            if (status == XmlListModel.Ready && count > 0){
                theaterAddress = get(0).address
                theaterLatitude = get(0).tlatitude
                theaterLongitude = get(0).tlongitude
                theaterPostalCode = get(0).postalCode
                theaterCity = get(0).city
                theaterCinemaChain = get(0).cinemaChain
                theaterScreenCount = get(0).screenCount
                windowTitleBar.busy = false
                modelShowTimes.theaterCode = theaterCode
            }
        }
    }

    ModelShowTimes {
        id: modelShowTimes
        theaterCode: theaterCode
        showDate: showDate
    }

    LoadingOverlay {
        id: pageTheaterLoadingScreeningsOverlay
        visible: !modelShowTimes.status == XmlListModel.Ready
        loadingText: "Chargement des séances"
    }

    LoadingOverlay {
        id: pageTheaterLoadingTheaterOverlay
        visible: !modelSearchTheaters.status == XmlListModel.Ready
        loadingText: "Chargement du cinéma"
    }

    ToolBarLayout {
        id: buttonTools
        ToolIcon { iconId: "toolbar-back"; onClicked: { myPositionSource.stop(); myMenu.close(); pageStack.pop(); }  }
        ToolIcon {
            iconSource: enabled ? "image://theme/icon-m-toolbar-share-white" : "image://theme/icon-m-toolbar-share-dimmed-white"
            onClicked: {
                console.log("Sharing " + linkWeb);
                shareString.title=theaterName
                shareString.description="Cinéma sur AlloCiné"
                shareString.mimeType="text/x-url"
                shareString.text=linkWeb
                shareString.share();
            }
            enabled: linkWeb
        }
        ToolIcon { iconSource: enabled ? "image://theme/icon-m-toolbar-view-menu-white" : "image://theme/icon-m-toolbar-view-menu-dimmed" ; onClicked: myMenu.open(); enabled: linkWeb}

    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: theaterName ? theaterName : "Cinéma"
    }


    ListView {
        id:theaterMovies
        anchors.top:windowTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 5
        model:modelShowTimes
        header: ItemTheaterDetails {
            showMap: true
            theaterAddress: pageTheater.theaterAddress
            theaterLatitude: pageTheater.theaterLatitude
            theaterLongitude: pageTheater.theaterLongitude
            theaterPostalCode: pageTheater.theaterPostalCode
            theaterCity: pageTheater.theaterCity
            theaterCinemaChain: pageTheater.theaterCinemaChain
            theaterScreenCount: pageTheater.theaterScreenCount
        }

        spacing: 10
        cacheBuffer: 3000
        visible: !noShow.visible && !pageTheaterLoadingScreeningsOverlay.visible && !pageTheaterLoadingTheaterOverlay.visible

        delegate:Component{

            Column {

                width: pageTheater.width

                ModelScreeningDate{
                    id:screeningDateModel
                    theaterCode:pageTheater.theaterCode
                    movieCode:model.mCode
                    xml:(extender.extended?theaterMovies.model.xml:"")
                    versionCode:model.versionCode
                    screenFormatCode:model.screenFormatCode
                    onCountChanged: console.debug(count)
                    onStatusChanged: if(status===XmlListModel.Ready)
                                         windowTitleBar.busy=false
                                     else
                                         windowTitleBar.busy=true
                }

                //                Component.onCompleted: {
                //                    //console.debug(code +" - "+ mCode)
                //                    screening.model=screeningDateModel.createObject(screening,{theaterCode:theaterCode,movieCode:mCode, xml:theaterMovies.model.xml, versionCode:versionCode, screenFormatCode:screenFormatCode})
                //                }

                ListComponentMovie {
                    movieActors: model.actors
                    movieCode: model.mCode
                    movieDirectors: model.directors
                    movieReleaseDate: model.releaseDate
                    movieTitle: model.title
                    moviePoster: model.poster
                }

                // versionRow
                Row {
                    id: versionRow
                    anchors.horizontalCenter: parent.horizontalCenter

                    //showTimesLabel
                    Label {
                        id: showTimesLabel
                        text: "Séances "
                        color: "ghostwhite"
                    }

                    Label {
                        id: versionLabel
                        text: model.version
                        font.weight: Font.Light
                        elide: Text.ElideRight
                        color: "ghostwhite"
                        visible: model.version != ""
                    }

                    Label {
                        text: " - "
                        font.weight: Font.Light
                        elide: Text.ElideRight
                        color: "ghostwhite"
                        visible: model.screenFormat != ""
                    }

                    Label {
                        id: screenFormatLabel
                        text: model.screenFormat
                        font.weight: Font.Light
                        elide: Text.ElideRight
                        color: "ghostwhite"
                        visible: model.screenFormat != ""
                    }
                }

                //screening
                Repeater{
                    id:screening
                    visible: status===XmlListModel.Ready
                    model:screeningDateModel
                    Row{
                        height: dateLabel.height
                        width : pageTheater.width
                        visible:   extender.extended

                        Component.onCompleted: {
                            //console.debug(code +" - "+ mCode)
                            screeningTime.model=screeningTimeModel.createObject(screening,{theaterCode:theaterCode,movieCode:mCode,screeningDate:date, xml:theaterMovies.model.xml, versionCode:versionCode, screenFormatCode:screenFormatCode})
                        }


                        Item{
                            height: dateLabel.height
                            width: parent.width

                            Label {
                                id: dateLabel
                                text: DateTools.formatDate(new Date(DateTools.getDateFromFormat(model.date, "yyyy-MM-d")), "EE")
                                elide: Text.ElideRight
                                color: "gold"
                                width: 120
                            }

                            ListView{
                                clip:true
                                height: dateLabel.height
                                orientation: Qt.Horizontal
                                anchors{left:dateLabel.right;right: parent.right; rightMargin:20}
                                id:screeningTime
                                delegate:Component{
                                    Row {

                                        Label{
                                            text: "   "+time
                                            color: "ghostwhite"
                                            //elide: Text.ElideRight

                                        }
                                    }
                                }
                            }
                        }
                    }


                }

                ItemExtender {
                    id: extender

                }

            }
        }
    }

    // noShow
    Item {
        id: noShow
        visible: modelShowTimes.status == XmlListModel.Ready && modelSearchTheaters.status == XmlListModel.Ready && modelSearchTheaters.count > 0 && modelShowTimes.count == 0
        anchors.top:windowTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 5

        ItemTheaterDetails {
            id: noShowTheaterDetails
            showMap: true
            theaterAddress: pageTheater.theaterAddress
            theaterLatitude: pageTheater.theaterLatitude
            theaterLongitude: pageTheater.theaterLongitude
            theaterPostalCode: pageTheater.theaterPostalCode
            theaterCity: pageTheater.theaterCity
            theaterCinemaChain: pageTheater.theaterCinemaChain
            theaterScreenCount: pageTheater.theaterScreenCount
        }

        Rectangle {
            anchors.top: noShowTheaterDetails.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: "transparent"

            Label {
                anchors.centerIn: parent
                text: "Aucune projection programmée"
                color: "gold"
            }
        }

    }

    Menu {
        id: myMenu

        MenuLayout {
            MenuItem { text: "Ouvrir dans le navigateur";
                onClicked: {
                    Qt.openUrlExternally(linkWeb)
                    console.log("Opening URL: " + linkWeb)
                }
            }
        }
    }
}
