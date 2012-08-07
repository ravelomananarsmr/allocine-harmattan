// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1

Item {
    property  int count:-1
    property int ratingValue:0
    property int maximumValue: 0

    width: rating.width
    height: Math.max(title.paintedHeight,rating.height)
    Row {
        id: rating
        Repeater{
            model: 5
            Image {
                width: sourceSize.width
                height: sourceSize.height
                source: (ratingValue*5/maximumValue>index ? "Images/ratingIndicator-selected.svg":"Images/ratingIndicator.svg")
                fillMode: Image.PreserveAspectCrop
            }
        }
        Label{
            id: title
            anchors.verticalCenter: parent.verticalCenter
            visible: count >= 0
            text: "(" + count + ")"
            font.weight: Font.Light
            font.pixelSize: 18
            font.italic: true
        }
    }
}
