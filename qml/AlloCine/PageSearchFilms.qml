// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
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
                    noResultFoundBanner.show() ;
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
        cacheBuffer: 3000

        visible: moviesListView.model.status == XmlListModel.Ready

        model: modelSearchMovies

        header: Item {

            anchors.left: parent.left
            anchors.right: parent.right
            height: searchField.height + currentMovies.height

            ListComponentSearchField {
                id: searchField
                onAccepted: {
                    searchMovies(text)
                }
            }

            // currentMovies
            ListComponentLink {
                id: currentMovies
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: searchField.bottom
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
            movieProductionYear: model.productionYear
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
