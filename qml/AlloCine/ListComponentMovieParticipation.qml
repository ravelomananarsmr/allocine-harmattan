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

Item {

    property string movieCode
    property string movieTitle
    property string movieOriginalTitle
    property string movieDirectors
    property string moviePoster
    property string movieReleaseDate
    property string movieReleaseStateCode
    property string movieReleaseState
    property string movieProductionYear
    property string activity

    property string releaseStateCode_RELEASED : "3004"
    property string releaseStateCode_PLANNED_RELEASED_UNKNOWN_DATE : "3011"

    height: Math.max(detailsItem.height, posterImageContainer.height) + 20
    width: parent.width

    Rectangle {
        id: background
        anchors.fill: completeRow
        // Fill page borders
        anchors.leftMargin: -parent.anchors.leftMargin
        anchors.rightMargin: -parent.anchors.rightMargin
        visible: mouseArea.pressed
        color: "#202020"
    }

    Row {
        width: parent.width
        height: posterImageContainer.height
        spacing: 10
        id: completeRow

        Rectangle {
            id: posterImageContainer
            width: posterImage.width + 8
            height: Math.max(posterImage.height, 133) + 8
            anchors.top: parent.top
            anchors.verticalCenter: parent.verticalCenter
            color: "black"
            z:1

            Rectangle {
                id: posterWhiteOutline
                width: posterImage.width + 6
                height: Math.max(posterImage.height, 133) + 6
                anchors.centerIn: parent
                color: "white"
                z:2

                Image {
                    id: noPosterImage
                    source: "Images/empty.png"
                    width: 100
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                    z:3
                }

                Image {
                    id: posterImage
                    source: (moviePoster? moviePoster: "Images/empty.png")
                    width: 100
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                    z:4
                }
            }
        }

        Column {
            id: detailsItem
            width: parent.width - posterImageContainer.width - arrow.width - 20

            Label {
                id: titleLabel
                text: movieTitle
                font.weight: Font.Bold
                font.pixelSize: 26
                width: parent.width
                maximumLineCount: 1
                elide: Text.ElideRight
                color: "gold"
                visible: movieTitle != ""

            }
            Label {
                id: originalTitleLabel
                text: movieOriginalTitle ? movieOriginalTitle : "Titre inconnu"
                font.weight: Font.Bold
                font.pixelSize: 26
                width: parent.width
                maximumLineCount: 1
                elide: Text.ElideRight
                color: "gold"
                visible: movieTitle == ""
            }
            Label {
                id: activityLabel
                text: activity
                width: parent.width
                elide: Text.ElideRight
                color: "ghostwhite"
                visible: activity
            }
            Label {
                id: movieProductionYearLabel
                text: "Production: "+ movieProductionYear
                font.weight: Font.Light
                font.pixelSize: 22
                color: "ghostwhite"
                width: parent.width
                elide: Text.ElideRight
                visible: movieProductionYear
            }
            Label {
                id: movieReleaseDateLabel_RELEASED
                text: movieReleaseDate ? "Sortie en salle: "+ DateTools.formatDate(new Date(DateTools.getDateFromFormat(movieReleaseDate, "yyyy-MM-d")), "dd MMM yyyy") : "Date de sortie inconnue"
                font.weight: Font.Light
                font.pixelSize: 22
                color: "ghostwhite"
                width: parent.width
                elide: Text.ElideRight
                visible: movieReleaseStateCode == releaseStateCode_RELEASED || (!movieReleaseStateCode && movieReleaseDate)
            }
            Label {
                id: movieReleaseDateLabel_PLANNED_RELEASED
                text: "Sortie en salle: "+ movieReleaseState
                font.weight: Font.Light
                font.pixelSize: 22
                color: "ghostwhite"
                width: parent.width
                elide: Text.ElideRight
                visible: movieReleaseStateCode == releaseStateCode_PLANNED_RELEASED_UNKNOWN_DATE
            }
        }
    }

    Image {
        id: arrow
        source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
        anchors.right: parent.right;
        anchors.verticalCenter: parent.verticalCenter
    }

    MouseArea {
        id: mouseArea
        anchors.fill: background
        onClicked: {
            var component = Qt.createComponent("PageMovie.qml")
            if (component.status == Component.Ready) {
                console.log("Selected movie: ", movieCode);
                pageStack.push(component, {
                    mCode: movieCode,
                    title: movieTitle ? movieTitle : movieOriginalTitle
                 });
            } else {
                console.log("Error loading component:", component.errorString());
             }
         }
    }
}
