// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1

Item {
    id: myItem
    property string icon
    property string text
    property int separation: pageMargin
    property int minimumHeight: 64

    height: Math.max(iconImage.height, labelText.height, minimumHeight)

    signal clicked()

    Rectangle {
        id: background
        anchors.fill: parent
        visible: mouseArea.pressed
        color: colorSelectedListItem
    }

    Image {
        id: iconImage
        source: icon
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: pageMargin
    }
    Label {
        id: labelText
        anchors.left: iconImage.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: separation
        wrapMode: Text.Wrap
        width: parent.width - arrow.width - iconImage.width
        text: myItem.text
    }
    Image {
        id: arrow
        source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
        anchors.right: parent.right;
        anchors.verticalCenter: parent.verticalCenter
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }

    Component.onCompleted: {
        mouseArea.clicked.connect(clicked)
    }
}
