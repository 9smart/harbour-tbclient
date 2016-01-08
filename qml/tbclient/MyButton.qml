import QtQuick 2.0
import Sailfish.Silica 1.0
import "Component"
import "Base"

MouseArea {
    id: button

    property bool down: pressed && containsMouse
    property alias text: buttonText.text
    property bool _showPress: down || pressTimer.running
    property color color: Theme.primaryColor
    property color highlightColor: Theme.highlightColor
    property alias font: buttonText.font

    onPressedChanged: {
        if (pressed) {
            pressTimer.start()
        }
    }
    onCanceled: pressTimer.stop()

    height: Theme.itemSizeSmall
    width: Math.max(buttonText.width, 214/480*Screen.width)

    Column {
        width: parent.width
        anchors.centerIn: parent
        spacing: -Theme.paddingSmall
        opacity: button.enabled ? 1.0 : 0.4
        Label {
            id: buttonText
            anchors.horizontalCenter: parent.horizontalCenter
            color: _showPress ? button.highlightColor : button.color
        }
        GlassItem {
            width: parent.width
            height: Theme.itemSizeExtraSmall/2
            color: _showPress ? button.highlightColor : button.color
            radius: _showPress ? 0.15 : 0.06
            falloffRadius: _showPress ? 0.23 : 0.14
            Behavior on radius { NumberAnimation { duration: 50; easing.type: Easing.InOutQuad }}
            Behavior on falloffRadius { FadeAnimation { duration: 50; easing.type: Easing.InOutQuad }}
            ratio: 0.0
        }
    }
    Timer {
        id: pressTimer
        interval: 50
    }
}
