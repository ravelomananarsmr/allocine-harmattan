// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: myItem
    property string shortText
    property string longText
    property string title

    property int separation: pageMargin
    height: titleLabel.height + textLabel.height + extender.height

    signal clicked()

    Label {
        id: titleLabel
        text: title
        color: "ghostwhite"
        font.weight: Font.Bold
    }

    Text {
        id: textLabel
        anchors.top: titleLabel.bottom
        text: shortText
        width: parent.width
        color: "ghostwhite"
        wrapMode: Text.Wrap
        horizontalAlignment:  Text.AlignJustify
        font.pointSize: titleLabel.font.pointSize
    }

    ItemExtender {
        id: extender
        anchors.top: textLabel.bottom
        onClicked: {
            if (textLabel.text == shortText) {
                textLabel.text = longText;
            } else if (textLabel.text == longText) {
                textLabel.text = shortText;
            }
        }
    }

    Component.onCompleted: {
        mouseArea.clicked.connect(clicked)
    }
}
