// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "Helpers.js" as Helpers
//import com.nokia.symbian 1.1

Page {
    id: filmsPage
    tools: buttonTools

    function filterMovies(text) {
        console.log("Filtering movies on " + text);
        currentMoviesModel.query = "/feed/movie[contains(lower-case(child::title),lower-case(\""+text+"\"))]";
        currentMoviesModel.reload();
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: "Films à l'affiche"
    }

    LoadingOverlay {
        id: pageCurrentFilmsLoadingOverlay
        visible: (currentMoviesModel.status == XmlListModel.Loading)
        loadingText: "Recherche des films à l'affiche"
    }

    // moviesView
    ListView {
        id: moviesListView
        anchors.top: windowTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cacheBuffer: 3000

        model: currentMoviesModel
        header: Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: filterField.height

            ListComponentSearchField {
                id: filterField
                placeholderText: "Filtrer"
                onAccepted: {
                    filterMovies(filterField.text)
                }
            }
        }

        delegate: ListComponentMovie {
            movieActors: model.actors
            movieCode: model.code
            movieDirectors: model.directors
            movieOriginalTitle: model.originalTitle
            movieTitle: model.title
            moviePoster: model.poster
            movieReleaseDate: model.releaseDate
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
}
