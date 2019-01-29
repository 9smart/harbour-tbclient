import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: detailItem
    width: parent.width
    height: Math.max(labelText.height, valueText.height) + 2*Theme.paddingSmall

    property alias label: labelText.text
    property alias value: valueText.text
    property real leftMargin: Theme.horizontalPageMargin
    property real rightMargin: Theme.horizontalPageMargin

    Text {
        id: labelText

        y: Theme.paddingSmall
        anchors {
            left: parent.left
            right: parent.horizontalCenter
            rightMargin: Theme.paddingSmall
            leftMargin: detailItem.leftMargin
        }
        horizontalAlignment: Text.AlignRight
        color: Theme.secondaryHighlightColor
        font.pixelSize: Theme.fontSizeSmall
//        font.family: myfont.name
        textFormat: Text.PlainText
        wrapMode: Text.Wrap
    }

    Text {
        id: valueText

        y: Theme.paddingSmall
        anchors {
            left: parent.horizontalCenter
            right: parent.right
            leftMargin: Theme.paddingSmall
            rightMargin: detailItem.rightMargin
        }
        horizontalAlignment: Text.AlignLeft
        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeSmall
//        font.family: myfont.name
        textFormat: Text.PlainText
        wrapMode: Text.Wrap
    }
}
