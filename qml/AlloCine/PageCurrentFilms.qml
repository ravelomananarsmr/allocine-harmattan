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
        //xmlModel.query = "/catalog/book[contains(lower-case(child::author),lower-case(\""+filter.text+"\"))]";
        currentMoviesModel.query = "/feed/movie[contains(lower-case(child::title),lower-case(\""+text+"\"))]";
        currentMoviesModel.reload();
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: "Films à l'affiche"
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
            height: filterField.height + 10

            // filterField
            TextField {
                id: filterField
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                placeholderText: "Recherche"

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
                        text: model.movieType + " - "+ model.productionYear + " - " + Helpers.formatSecondsAsTime(model.runtime, 'hh:mm')
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
