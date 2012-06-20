// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: myItem
    property string title
    property string content
    property variant horizontalAlignment: Text.AlignLeft

    height: titleLabel.height + contentText.height

    Label {
        id: titleLabel
        text: title
        color: "ghostwhite"
        font.weight: Font.Bold
    }
    Text {
        id: contentText
        anchors.top: titleLabel.bottom
        text: content
        width: parent.width
        color: "ghostwhite"
        wrapMode: Text.Wrap
        horizontalAlignment:  myItem.horizontalAlignment
        font.pointSize: titleLabel.font.pointSize
    }
}
