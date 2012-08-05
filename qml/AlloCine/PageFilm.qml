import QtQuick 1.1
import com.nokia.meego 1.1

import "Helpers.js" as Helpers

Page {
    id: filmPage
    tools: buttonTools

    orientationLock: PageOrientation.LockPortrait
    property int mCode
    property string title
    property string trailerUrlId
    property string linkWeb

    ToolBarLayout {
        id: buttonTools

        ToolIcon { iconId: "toolbar-back"; onClicked: {pageStack.pop(); }  }
        ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: title
        windowTitleBackup: "Pas de titre"
    }

    LoadingOverlay {
        id: filmPageLoadingOverlay
        onVisibleChanged: {
            if (visible) {
                movieListView.visible = false
            } else {
                movieListView.visible = true
            }
        }
    }

    ModelMovie {
        id: modelMovie
        mCode: filmPage.mCode
        onStatusChanged: {
            if (status == XmlListModel.Ready && count > 0){
                filmPageLoadingOverlay.visible = false
            }
        }
    }

    ListView {
        id: movieListView
        anchors.top: parent.top
        anchors.topMargin: windowTitleBar.height
        anchors.margins: pageMargin
        anchors.fill: parent
        Component.onCompleted: {
            filmPageLoadingOverlay.visible = true
            filmPageLoadingOverlay.loadingText = "Chargement du film"
        }
        model: modelMovie

        delegate: Column {
            width: parent.width
            spacing: pageMargin
            Component.onCompleted: {
                var RegularExpression = /\/(\d+)$/
                var filteredTrailerId = RegularExpression.exec(model.trailer)
                //console.log("Filtered Trailer ID: " + model.trailer + " -> " + filteredTrailerId[1])
                if (model.trailer)
                    trailerUrlId = filteredTrailerId[1]
                var linkWeb = model.linkWeb

                genreRepeater.model=genreModel.createObject(genreRepeater,{xml:movieListView.model.xml})

            }

            Item {
                width: parent.width
                height: Math.max(posterBlackOutline.height, mainDetails.height)

                // posterImage
                Rectangle {
                    id: posterBlackOutline
                    width: posterImage.width + 7
                    height: posterImage.height + 7
                    color: "black"
                    z:1

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        enabled: model.poster
                        onClicked: {
                            var component = Qt.createComponent("PagePicture.qml")
                            if (component.status == Component.Ready) {
                                pageStack.push(component, {imageSource: model.poster? model.poster: "Images/empty.png", title: title});
                            } else {
                                console.log("Error loading component:", component.errorString());
                            }
                        }
                    }

                    Rectangle {
                        id: posterWhiteOutline
                        width: posterImage.width + 5
                        height: posterImage.height + 5
                        anchors.centerIn: parent
                        color: "white"
                        z:2

                        Image {
                            id: posterImage
                            source: (model.poster? model.poster: "Images/empty.png")
                            width: 150
                            fillMode: Image.PreserveAspectFit
                            anchors.centerIn: parent
                            z:4
                        }
                    }
                }

                // mainDetails
                Column{
                    id: mainDetails
                    anchors.left: posterBlackOutline.right
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

            Row {
                Repeater{
                    id:genreRepeater
                    width: parent.width

                    Row {
                        Label {
                            id: genreLabel
                            text: model.genreText
                            elide: Text.ElideRight
                            color: "ghostwhite"
                        }
                        Label {
                            id: commaLabel
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
                        ratingValue: model.pressRating
                        maximumValue: 5
                        count: model.pressReviewCount
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

                        ratingValue: model.userRating
                        maximumValue: 5
                        count: model.userRatingCount
                     }

                }

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
                    Qt.openUrlExternally(linkWeb)
                    console.log("Opening URL: " + linkWeb)
                }
            }
//            MenuItem { text: "Partager";
//                onClicked: {
//                    Qt.openUrlExternally(linkWeb)
//                    console.log("Opening URL: " + linkWeb)
//                }
//            }
        }
    }
}
