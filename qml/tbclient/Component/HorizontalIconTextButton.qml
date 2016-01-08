import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Base"

MouseArea {
    id:horizontalIconTextButton

    property bool down: pressed && containsMouse
    property alias text: buttonText.text
    property int fontSize: Theme.fontSizeSmall//Math.min(image.width, image.height)
    property bool _showPress: down || pressTimer.running
    property color color: Theme.primaryColor
    property color highlightColor: Theme.highlightColor
    property int spacing: Theme.paddingSmall
    property alias icon: image.source
    property real iconSize: Theme.iconSizeMedium
    //property alias source: image.source

    onPressedChanged: {
        if (pressed) {
            pressTimer.start()
        }
        console.log("999999999999")
    }
    onCanceled: pressTimer.stop()

    width: image.width + buttonText.width + horizontalIconTextButton.spacing
    height: Math.max(image.height, buttonText.height)

    Timer {
        id: pressTimer
        interval: 50
    }
    Row {
        id: row
        spacing: horizontalIconTextButton.spacing
        Image {
            id:image
            fillMode: Image.PreserveAspectFit
            width: horizontalIconTextButton.iconSize
            height: image.width
        }
        Label {
            id:buttonText
            height: implicitHeight
            anchors.verticalCenter: image.verticalCenter
            color: _showPress ? horizontalIconTextButton.highlightColor : horizontalIconTextButton.color
            font.pixelSize: horizontalIconTextButton.fontSize
        }
    }
}
