// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    property string loadingText: "Chargement"
    anchors.fill: parent
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    z: 100
    visible: false

    BusyIndicator {
        id: busyIndicator
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        running: true
        platformStyle: BusyIndicatorStyle { size: "large" }
    }
    Label {
        id: loadingLabel
        anchors.top: busyIndicator.bottom
        anchors.topMargin: busyIndicator.height / 3
        anchors.horizontalCenter: parent.horizontalCenter
        text: loadingText
    }
}
