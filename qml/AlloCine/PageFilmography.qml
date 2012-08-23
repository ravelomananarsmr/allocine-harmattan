import QtQuick 1.1
import com.nokia.meego 1.1

Page {
    id: filmographyPage
    tools: buttonTools

    property string name
    property string code

    ToolBarLayout {
        id: buttonTools
        ToolIcon { iconId: "toolbar-back"; onClicked: {pageStack.pop(); }  }
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: "Filmographie de " + name
    }

    LoadingOverlay {
        id: castingOverlay
        visible: modelFilmography.status == XmlListModel.Loading
    }

    ModelFilmography {
        id: modelFilmography
        personCode: code
    }

    ListView {
        id: filmographyListView
        anchors.top: windowTitleBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        model: modelFilmography
        delegate: ListComponentMovieParticipation {
            movieCode: model.movieCode
            movieOriginalTitle: model.movieOriginalTitle
            movieTitle: model.movieTitle
            moviePoster: model.moviePoster
            movieReleaseDate: model.movieReleaseDate
            movieReleaseState: model.movieReleaseState
            movieReleaseStateCode: model.movieReleaseStateCode
            movieProductionYear: model.movieProductionYear
            activity: model.activity
        }
    }

    ScrollDecorator {
        flickableItem: filmographyListView
    }

}
