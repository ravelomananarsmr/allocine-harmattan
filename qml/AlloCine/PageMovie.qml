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
import "DateTools.js" as DateTools
import "Helpers.js" as Helpers

Page {
    id: pageMovie
    tools: buttonTools

    property string mCode
    property string title
    property string trailerUrlId
    property string movieLinkWeb

    ToolBarLayout {
        id: buttonTools

        ToolIcon { iconId: "toolbar-back"; onClicked: {pageStack.pop(); }  }
        ToolIcon {
            iconSource: enabled ? "image://theme/icon-m-toolbar-share-white" : "image://theme/icon-m-toolbar-share-dimmed-white"
            onClicked: {
                console.log("Sharing " + movieLinkWeb);
                shareString.title=title
                shareString.description="Film sur AlloCiné"
                shareString.mimeType="text/x-url"
                shareString.text=movieLinkWeb
                shareString.share();
            }
            enabled: movieLinkWeb
        }
        ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); enabled: movieLinkWeb}
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: title
        windowTitleBackup: "Titre inconnu"
    }

    LoadingOverlay {
        id: filmPageLoadingOverlay
        visible: modelMovie.xml == "" || !(posterImage.status == Image.Ready && modelMovie.status == XmlListModel.Ready && modelNationality.status == XmlListModel.Ready && modelGenre.status == XmlListModel.Ready)
        loadingText: "Chargement du film"
    }

    ModelMovie {
        id: modelMovie
        mCode: pageMovie.mCode
        onStatusChanged: {
            if (status == XmlListModel.Ready){
                modelGenre.xml = xml
                modelNationality.xml = xml
            }
        }
    }

    ModelGenre {
        id: modelGenre
    }

    ModelNationality {
        id: modelNationality
    }

    ListView {
        id: movieListView
        anchors.top: parent.top
        anchors.topMargin: windowTitleBar.height
        anchors.margins: pageMargin
        anchors.fill: parent

        model: modelMovie
        visible: !filmPageLoadingOverlay.visible

        delegate: Column {
            width: parent.width
            spacing: pageMargin
            Component.onCompleted: {
                var RegularExpression = /\/(\d+)$/
                var filteredTrailerId = RegularExpression.exec(model.trailer)
                //console.log("Filtered Trailer ID: " + model.trailer + " -> " + filteredTrailerId[1])
                if (model.trailer){
                    trailerUrlId = filteredTrailerId[1]
                }
                pageMovie.mCode = model.mCode
                movieLinkWeb = model.linkWeb
            }

            // header
            Item {
                width: parent.width
                height: Math.max(itemPoster.height, mainDetails.height)

                // poster
                ItemPoster {
                    id:itemPoster
                    url: model.poster

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        enabled: model.poster
                        onClicked: {
                            var component = Qt.createComponent("PagePicture.qml")
                            if (component.status == Component.Ready) {
                                pageStack.push(component, {imageSource: model.poster? model.poster: "Images/empty.png", title: model.title});
                            } else {
                                console.log("Error loading component:", component.errorString());
                            }
                        }
                    }
                }

                // mainDetails
                Column{
                    id: mainDetails
                    anchors.left: itemPoster.right
                    anchors.leftMargin: pageMargin
                    anchors.right: parent.right
                    anchors.top: parent.top
                    Text {
                        id: movieTitleYear
                        text: model.title + " (" + model.productionYear + ")"
                        width: parent.width
                        wrapMode: Text.Wrap
                        font.weight: Font.Bold
                        font.pointSize: fontSizeLarge
                        color: "ghostwhite"
                    }

                    Label {
                        id: movieTypeLabel
                        text: model.movieType
                        color: "gold"
                        visible: text != ""
                    }

                    // versionRuntimeLabel
                    Row {
                        width: parent.width

                        Label {
                            id: versionRuntimeLabelTitle
                            text: "Durée: "
                            color: "gold"
                            visible: model.runtime
                        }
                        Label {
                            id: versionRuntimeLabel
                            text: Helpers.formatSecondsAsTime(model.runtime, 'hh:mm')
                            width: parent.width - versionRuntimeLabelTitle.width
                            color: "ghostwhite"
                            elide: Text.ElideRight
                            visible: model.runtime
                        }
                    }
                }
            }

            // genre
            Row {
            Repeater{
                id:genreRepeater
                width: parent.width
                model: modelGenre
                Row {
                    Label {
                        id: genreLabel
                        text: model.genre
                        elide: Text.ElideRight
                        color: "ghostwhite"
                    }
                    Label {
                        text: ", "
                        elide: Text.ElideRight
                        color: "ghostwhite"
                        visible: (index + 1 != genreRepeater.count)
                    }
                }

            }
        }

            // certificateLabel
            Text {
                id: certificateLabel
                text: model.certificate
                width: parent.width
                color: "gold"
                wrapMode: Text.Wrap
                font.pointSize: fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
                visible: (model.certificate)
            }

            // ratingsRow
            Item {
                id: ratingsRow
                anchors.left: parent.left
                anchors.right: parent.right
                height: pressRatingItem.height

                Item {
                    id: pressRatingItem
                    height: pressRatingItemLabel.height + pressRatingItemStars.height
                    width: Math.max(pressRatingItemLabel.width, pressRatingItemStars.width)
                    anchors.left: parent.left
                    anchors.top: parent.top

                    Label {
                        id: pressRatingItemLabel
                        text: "Presse"
                        color: "ghostwhite"
                        font.weight: Font.Bold
                    }

                    RatingIndicator {
                        id: pressRatingItemStars
                        anchors.top: pressRatingItemLabel.bottom
                        ratingValue: model.pressRating ? model.pressRating : 0
                        maximumValue: 5
                        count: model.pressReviewCount ? model.pressReviewCount : 0
                     }

                }

                Item {
                    id: userRatingItem
                    anchors.left: pressRatingItem.right
                    anchors.leftMargin: pageMargin
                    anchors.top: parent.top
                    height: userRatingItemLabel.height + userRatingItemStars.height
                    width: Math.max(userRatingItemLabel.width, userRatingItemStars.width)

                    Label {
                        id: userRatingItemLabel
                        text: "Spectateurs"
                        color: "ghostwhite"
                        font.weight: Font.Bold
                    }

                    RatingIndicator {
                        id: userRatingItemStars
                        anchors.top: userRatingItemLabel.bottom

                        ratingValue: model.userRating ? model.userRating : 0
                        maximumValue: 5
                        count: model.userRatingCount ? model.userRatingCount : 0
                     }

                }

            }

            // nationality
            Item {
                height: nationalityLabelTitle.height + nationalityRow.height
                width: parent.width
                visible: modelNationality.count > 0

                Label {
                    id: nationalityLabelTitle
                    text: "Pays"
                    color: "ghostwhite"
                    font.weight: Font.Bold
                }

                Row {
                    id: nationalityRow
                    anchors.top: nationalityLabelTitle.bottom
                    Repeater{
                        id:nationalityRepeater
                        width: parent.width
                        model: modelNationality
                        Row {
                            Label {
                                id: nationalityLabel
                                text: model.nationality
                                elide: Text.ElideRight
                                color: "ghostwhite"
                            }
                            Label {
                                text: ", "
                                elide: Text.ElideRight
                                color: "ghostwhite"
                                visible: (index + 1 != nationalityRepeater.count)
                            }
                        }
                    }
                }
            }

            // release date
            ListComponentText{
                width: parent.width
                title: "Sortie " + model.country + ((model.releaseVersion ? " (" + releaseVersion + ")" : ""))
                content: DateTools.formatDate(new Date(DateTools.getDateFromFormat(model.releaseDate, "yyyy-MM-d")), "dd MMM yyyy")
                visible: model.releaseDate
            }

            // directors
            ListComponentText{
                width: parent.width
                title: "Réalisation"
                content: model.directors
                visible: model.directors
            }

            // actors
            ListComponentText{
                width: parent.width
                title: "Acteurs"
                content: model.actors
                visible: model.actors
            }

            // completeCast
            ListComponentLink {
                anchors.left: parent.left
                anchors.right: parent.right
                icon: "image://theme/icon-m-content-avatar-placeholder-inverse"
                text: "Casting Complet"
                onClicked: {
                    var component = Qt.createComponent("PageCasting.qml")
                    if (component.status == Component.Ready) {
                        pageStack.push(component, {title: title});
                    } else {
                        console.log("Error loading component:", component.errorString());
                    }
                }
            }

            // synopsis           
            ListComponentExtend {
                anchors.left: parent.left
                anchors.right: parent.right
                title: "Synopsis"
                shortText: model.synopsisShort
                longText: model.synopsis
                visible: model.synopsisShort
            }

            // trailer
            ListComponentLink {
                anchors.left: parent.left
                anchors.right: parent.right
                icon: "image://theme/icon-m-content-videos-inverse"
                text: "Bande Annonce"
                onClicked: {
                    Qt.openUrlExternally(mobileVideoUrl + trailerUrlId)
                    console.log("Opening URL: " + mobileVideoUrl + trailerUrlId)
                }
                visible: trailerUrlId
            }

            // distributor
            ListComponentText{
                width: parent.width
                title: "Distributeur"
                content: model.distributor
                visible: model.distributor
            }

        }
    }

    ScrollDecorator {
        flickableItem: movieListView
    }

    Menu {
        id: myMenu

        MenuLayout {
            MenuItem { text: "Ouvrir dans le navigateur";
                onClicked: {
                    Qt.openUrlExternally(movieLinkWeb)
                    console.log("Opening URL: " + movieLinkWeb)
                }
            }
//            MenuItem { text: "Trouver un cinéma";
//                onClicked: {
//                    var component = Qt.createComponent("PageMovieShowTimes.qml")
//                    if (component.status == Component.Ready) {
//                        pageStack.push(component, {mCode: mCode, title: title});
//                    } else {
//                        console.log("Error loading component:", component.errorString());
//                    }
//                }
//            }
        }
    }
}
