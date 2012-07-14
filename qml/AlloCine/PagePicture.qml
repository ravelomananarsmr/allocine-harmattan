import QtQuick 1.1
import com.nokia.meego 1.0
import "Helpers.js" as Helpers
import "DateTools.js" as DateTools

Page {
    id: pagePicture
    tools: buttonTools

    property string source
    property string title

    ToolBarLayout {
        id: buttonTools

        ToolIcon { iconId: "toolbar-back"; onClicked: {pageStack.pop(); }  }
        //ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
    }

    WindowTitle {
        id: windowTitleBar
        windowTitle: title
        windowTitleBackup: "Pas de titre"
    }

    LoadingOverlay {
        id: pagePictureLoadingOverlay
    }

    Item {
        anchors.top: windowTitleBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Image {
            source: source
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            width: 150
        }
    }
}
