// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1

Item {
     property  int count:-1
    property int ratingValue:0
    property int maximumValue: 0
    property string unfilledColor:"ghostwhite"
    property string filledColor:"gold"
    width: rating.width+title.paintedWidth
    height: Math.max(title.paintedHeight,rating.height)
     Row {
             id: column1

             width: rating.width+title.width
             height: Math.max(title.height,rating.height)
        Rectangle{
            color:unfilledColor
            width: rating.width
            height: rating.height
            Rectangle{
                height: rating.height
                width:ratingValue*rating.width/maximumValue
                color:filledColor
            }

            Image {
            id: rating
            sourceSize.width: 75
            sourceSize.height: 20
            width: sourceSize.width
            height: sourceSize.height
            source: "Images/ratingIndicator.svg"
            fillMode: Image.PreserveAspectCrop
            }
        }
        Label{
            id: title
            visible: count >= 0
            text: "(" + count + ")"
             font.weight: Font.Light
            font.pixelSize: 18
            font.italic: true
        }
       }
}
