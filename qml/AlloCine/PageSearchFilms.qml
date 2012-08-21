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
//        timeout: 1000
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
                    noResultFoundBanner.open() ;
                    console.debug("No result")
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

        delegate: ListComponentMovie {
            movieActors: model.actors
            movieCode: model.code
            movieDirectors: model.directors
            movieOriginalTitle: model.originalTitle
            movieReleaseDate: model.releaseDate
            movieTitle: model.title
            moviePoster: model.poster
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

//        MenuLayout {
//            MenuItem { text: "Test"; }
//        }
//    }
}
