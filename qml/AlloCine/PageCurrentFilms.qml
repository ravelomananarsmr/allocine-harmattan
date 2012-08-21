// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
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
        anchors.topMargin: 16
        cacheBuffer: 3000

        model: currentMoviesModel
        header: Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: filterField.height + 2 * anchors.margins
            anchors.margins: 16

            // filterField
            TextField {
                id: filterField
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                //anchors.verticalCenter: parent.verticalCenter
                placeholderText: "Filtrer"

                //if user is typing fast, we don't want to search on every key-press
                Timer{
                   id: filterTimer
                   interval:500
                   running: false
                   repeat: false

                   onTriggered: {
                       filterMovies(filterField.text)
                   }
                }

                onTextChanged:{
                    console.log(filterField.text);
                    if(filterTimer.running){
                        console.log("restarted");
                        filterTimer.restart()
                    }else{
                        console.log("started");
                        filterTimer.start()
                    }
                }

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
                        height: filterField.height; width: filterField.height
                        onClicked: {
                            filterMovies(filterField.text)
                        }
                    }
                }

                onAccepted: {
                    searchMovies(searchField.text)
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
