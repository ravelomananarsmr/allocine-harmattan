// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1
import "Helpers.js" as Helpers
//import com.nokia.symbian 1.1

Page {
    id: personsPage
    tools: buttonTools

    function searchPersons(text) {
        console.log("Search movies with " + text);
        modelSearchPersons.personQuery = text;
        modelSearchPersons.reload();
    }

    InfoBanner {
        id: noResultFoundBanner
        text: "Aucune personne trouvée"
//        timeout: 1000
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: "Personnes"
    }

    LoadingOverlay {
        id: searchPersonsLoadingOverlay
        visible: modelSearchPersons.status == XmlListModel.Loading
    }

    ModelSearchPersons {
        id: modelSearchPersons
        onStatusChanged: {
            if (status == XmlListModel.Ready){
                if (count == 0 && xml){
                    noResultFoundBanner.open() ;
                    console.debug("No result")
                }
            }
        }
    }

    // personsView
    ListView {
        id: personsListView
        anchors.top: windowTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        //anchors.topMargin: 16
        cacheBuffer: 3000

        visible: personsListView.model.status == XmlListModel.Ready

        model: modelSearchPersons

        header: ListComponentSearchField {
            id: searchField
            onAccepted: {
                searchPersons(text)
            }
        }

        delegate: ListComponentPerson {
            personBirthDate: model.birthDate
            personCode: model.code
            personGender: model.gender
            personName: model.name
            personPicture: model.picture
        }
    }

    ScrollDecorator {
        flickableItem: personsListView
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
