// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

// windowTitleBar
Item {
    id: windowTitleBar
    //anchors.top: screening.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 70
    z: 1000
    property string windowTitle: "AlloCine"
    property string windowTitleBackup: "AlloCine"


    Rectangle {
        id: windowTitleRectangle
        color: "gold"
        anchors.fill: parent
    }

    Label {
        id: windowTitleTextLabel
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        text: windowTitle
        font.weight: Font.Light
        font.pointSize: fontSizeMedium
        color: "white"
        width: parent.width - 2*anchors.leftMargin
        elide: Text.ElideRight
        visible: windowTitle != ""
    }

    Label {
        id: windowTitleBackupTextLabel
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        text: windowTitleBackup
        font.weight: Font.Light
        font.pixelSize: fontSizeLarge
        color: "white"
        width: parent.width - 2*anchors.leftMargin
        elide: Text.ElideRight
        visible: windowTitle == ""
    }
}
