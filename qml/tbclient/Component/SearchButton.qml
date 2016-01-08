import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Base"

MouseArea {
    id:root
    width: 100
    height: 62
    property bool active: false
    property string text: "Button"
    property int fontsize: constant.fontXSmall;
    property string color: Theme.primaryColor

    Label {
        id: buttonText
        text: root.text
        font.pixelSize:root.fontsize;
        anchors.centerIn: parent
        color: root.pressed ? Theme.highlightColor : root.color
    }
    Rectangle{
        anchors.left: parent.left;
        anchors.bottom: parent.bottom;
        transformOrigin :Item.BottomLeft
        width:1
        height:  parent.width;
        rotation: 90
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00ffffff" }
            GradientStop { position: 0.5; color: active ? Theme.rgba(Theme.highlightColor,0.5):"#00ffffff" }
            GradientStop { position: 1.0; color: "#00ffffff" }
        }
    }
}
