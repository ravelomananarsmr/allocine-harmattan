// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import "DateTools.js" as DateTools

Item {

    property string movieCode
    property string movieTitle
    property string movieOriginalTitle
    property string movieDirectors
    property string movieActors
    property string moviePoster
    property string movieReleaseDate

    height: Math.max(detailsItem.height, posterImageContainer.height) + 20
    width: parent.width

    Rectangle {
        id: background
        anchors.fill: completeRow
        // Fill page borders
        anchors.leftMargin: -listPage.anchors.leftMargin
        anchors.rightMargin: -listPage.anchors.rightMargin
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
                id: directorsLabel
                text: movieDirectors ? "De " + movieDirectors : "Réalisateur inconnu"
                width: parent.width
                elide: Text.ElideRight
                color: "ghostwhite"
            }
            Label {
                id: actorsLabel
                text: movieActors ? "Avec " + movieActors : "Acteurs inconnus"
                width: parent.width
                elide: Text.ElideRight
                color: "ghostwhite"
            }
            Label {
                id: movieReleaseDateLabel
                text: movieReleaseDate ? "Sortie le "+ DateTools.formatDate(new Date(DateTools.getDateFromFormat(movieReleaseDate, "yyyy-MM-d")), "dd MMM yyyy") : "Date de sortie inconnue"
                font.weight: Font.Light
                font.pixelSize: 22
                color: "ghostwhite"
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
