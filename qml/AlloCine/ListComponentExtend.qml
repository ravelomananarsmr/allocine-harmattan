// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: myItem
    property string shortText
    property string longText
    property string title

    property int separation: pageMargin
    height: titleLabel.height + textItem.height + extender.height

    signal clicked()

    Label {
        id: titleLabel
        text: title
        color: "ghostwhite"
        font.weight: Font.Bold
    }

    Item {
        id: textItem
        anchors.top: titleLabel.bottom
        width: parent.width

        Text {
            id: shortTextLabel
            text: shortText
            width: parent.width
            color: "ghostwhite"
            wrapMode: Text.Wrap
            horizontalAlignment:  Text.AlignJustify
            font.pointSize: titleLabel.font.pointSize
            visible: true
        }

        Text {
            id: longTextLabel
            text: longText
            width: parent.width
            color: "ghostwhite"
            wrapMode: Text.Wrap
            horizontalAlignment:  Text.AlignJustify
            font.pointSize: titleLabel.font.pointSize
            visible: false
            clip: true
        }
    }

    state: "SYNOPSYS_RETRACTED"

    states: [
        State {
             name: "SYNOPSYS_RETRACTED"
             PropertyChanges { target: shortTextLabel; visible: true }
             PropertyChanges { target: longTextLabel; visible: false }
             PropertyChanges { target: textItem; height: shortTextLabel.height }
             PropertyChanges { target: longTextLabel; height: textItem.height } // Hack to not have overlap between longtext and items below
         },

        State {
             name: "SYNOPSYS_EXTENDED"
             PropertyChanges { target: shortTextLabel; visible: false }
             PropertyChanges { target: longTextLabel; visible: true }
             PropertyChanges { target: textItem; height: longTextLabel.height }
             PropertyChanges { target: longTextLabel; height: longTextLabel.paintedHeight } // Hack to not have overlap between longtext and items below
         }
    ]

    transitions: [
        Transition {
            from: "SYNOPSYS_RETRACTED"
            to: "SYNOPSYS_EXTENDED"
            NumberAnimation { target: textItem; property: "height"; duration: extender.animationDuration; easing.type: Easing.InOutQuad }
            NumberAnimation { target: longTextLabel; property: "height"; duration: extender.animationDuration; easing.type: Easing.InOutQuad }
        },
        Transition {
            from: "SYNOPSYS_EXTENDED"
            to: "SYNOPSYS_RETRACTED"
            NumberAnimation { target: textItem; property: "height"; duration: extender.animationDuration; easing.type: Easing.InOutQuad }
            NumberAnimation { target: longTextLabel; property: "height"; duration: extender.animationDuration; easing.type: Easing.InOutQuad }
        }
    ]

    ItemExtender {
        id: extender
        anchors.top: textItem.bottom
        onClicked: {
            if (state == "RETRACTED") {
                myItem.state = "SYNOPSYS_RETRACTED"
            } else if (state == "EXTENDED") {
                myItem.state = "SYNOPSYS_EXTENDED"
            }
        }
        visible: (shortText != longText)
    }

    Component.onCompleted: {
        mouseArea.clicked.connect(clicked)
    }
}
