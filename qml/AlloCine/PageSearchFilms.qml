// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1
import "Helpers.js" as Helpers
//import com.nokia.symbian 1.1

Page {
    id: filmsPage
    tools: buttonTools

    function searchMovies(text) {
        //console.log("Search movies with " + text);
        modelSearchMovies.movieQuery = text;
        modelSearchMovies.reload();
    }

    InfoBanner {
        id: noResultFoundBanner
        text: "Aucun film trouvé"
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: "Films"
    }

    LoadingOverlay {
        id: searchFilmsLoadingOverlay
        visible: modelSearchMovies.status == XmlListModel.Loading
    }

    ModelSearchMovies {
        id: modelSearchMovies
        onStatusChanged: {
            if (status == XmlListModel.Ready){
                if (count == 0 && xml){
                    noResultFoundBanner.show();
                }
            }
        }
    }

    // moviesView
    ListView {
        id: moviesListView
        anchors.top: windowTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: 16
        cacheBuffer: 3000

        visible: moviesListView.model.status == XmlListModel.Ready

        model: modelSearchMovies

        header: Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: searchField.height + 10 + 16 *2 + currentMovies.height

            // searchField
            TextField {
                id: searchField
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                placeholderText: "Recherche"

                Image {
                    anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: 16 }
                    id: clearText
                    fillMode: Image.PreserveAspectFit
                    smooth: true;
                    source: "image://theme/icon-m-toolbar-search"
                    height: parent.height - platformStyle.paddingMedium * 2
                    width: parent.height - platformStyle.paddingMedium * 2

                    MouseArea {
                        id: searchMouseArea
                        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
                        height: searchField.height; width: searchField.height
                        onClicked: {
                            searchMovies(searchField.text)
                        }
                    }
                }

                onAccepted: {
                    searchMovies(searchField.text)
                }
            }

            // currentMovies
            ListComponentLink {
                id: currentMovies
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: searchField.bottom
                anchors.topMargin: 16
                icon: "image://theme/icon-m-toolbar-addressbook-selected"
                text: "Tous les films à l'affiche"
                onClicked: {
                    var component = Qt.createComponent("PageCurrentFilms.qml")
                    if (component.status == Component.Ready) {
                        pageStack.push(component, {});
                    } else {
                        console.log("Error loading component:", component.errorString());
                    }
                }
            }

        }

        delegate:  Item {
            id: listItem
            height: Math.max(detailsItem.height, posterImageContainer.height) + 20
            width: parent.width

            Rectangle {
                id: background
                anchors.fill: parent
                // Fill page borders
                anchors.leftMargin: -listPage.anchors.leftMargin
                anchors.rightMargin: -listPage.anchors.rightMargin
                visible: mouseArea.pressed
                color: "#202020"
            }

            Row {
                spacing: 10

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
                            source: (model.poster? model.poster: "Images/empty.png")
                            width: 100
                            fillMode: Image.PreserveAspectFit
                            anchors.centerIn: parent
                            z:4
                        }
                    }
                }

                Column {
                    id: detailsItem
                    width: filmsPage.width - posterImageContainer.width - arrow.width - 20

                    Label {
                        id: titleLabel
                        text: model.title
                        font.weight: Font.Bold
                        font.pixelSize: 26
                        width: parent.width
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        color: "ghostwhite"
                        visible: text != ""

                    }
                    Label {
                        id: originalTitleLabel
                        text: model.originalTitle
                        font.weight: Font.Bold
                        font.pixelSize: 26
                        width: parent.width
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        color: "ghostwhite"
                        visible: titleLabel.text == ""
                    }
                    Label {
                        id: directorsLabel
                        text: "De " + model.directors
                        width: parent.width
                        elide: Text.ElideRight
                        color: "ghostwhite"
                    }

                    Label {
                        id: actorsLabel
                        text: "Avec " + model.actors
                        width: parent.width
                        elide: Text.ElideRight
                        color: "ghostwhite"
                    }

                    Label {
                        id: movieTypeProductionYearRuntimeLabel
                        text: "Sorti en "+ model.productionYear
                        font.weight: Font.Light
                        font.pixelSize: 22
                        color: "gold"
                        width: parent.width
                        elide: Text.ElideRight
                        visible: text != ""
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
                    var component = Qt.createComponent("PageFilm.qml")
                    if (component.status == Component.Ready) {
                        console.log("Selected movie: ", model.code);
                        pageStack.push(component, {
                            mCode: model.code,
                            title: model.title
                         });
                    } else {
                        console.log("Error loading component:", component.errorString());
                     }
                 }
            }
        }
    }

    ScrollDecorator {
        flickableItem: moviesListView
    }

    ToolBarLayout {
        id: buttonTools
        ToolIcon { iconId: "toolbar-back"; onClicked: { /*myMenu.close();*/ pageStack.pop(); }  }
        //ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
    }


//    Menu {
//        id: myMenu
//        visualParent: pageStack

//        MenuLayout {
//            MenuItem { text: "Test"; }
//        }
//    }
}
