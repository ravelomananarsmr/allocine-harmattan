// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1

Item {
    id: myComponentSearchField
    property string placeholderText: "Recherche"
    property string text: myComponentSearchFieldTextField.text

    signal accepted()
    signal textChanged()

    height: 80

    anchors.topMargin: 10
    anchors.bottomMargin: 10

    anchors.leftMargin: 16
    anchors.rightMargin: 16

    anchors.left: parent.left
    anchors.right: parent.right

    TextField {
        id: myComponentSearchFieldTextField
        //anchors.fill: parent
        height: 50
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right

        placeholderText: myComponentSearchField.placeholderText

        Image {
            anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: 16 }
            id: clearText
            fillMode: Image.PreserveAspectFit
            smooth: true;
            source: "image://theme/icon-m-toolbar-search"
            height: parent.height - platformStyle.paddingMedium * 2
            width: parent.height - platformStyle.paddingMedium * 2

            MouseArea {
                id: myComponentSearchFieldMouseArea
                anchors.fill: parent
            }
        }

        Component.onCompleted: {
            myComponentSearchFieldMouseArea.clicked.connect(myComponentSearchField.accepted)
            myComponentSearchFieldTextField.accepted.connect(myComponentSearchField.accepted)
            myComponentSearchFieldTextField.textChanged.connect(myComponentSearchField.textChanged)
        }
    }
}
