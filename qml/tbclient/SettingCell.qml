import QtQuick 2.0
import Sailfish.Silica 1.0
import "Component"
import "Base"
Item {
    id: root;

    property string iconSource;
    property string title;
    property bool markVisible: false;

    signal clicked;

    width: parent.width / 4;
    height: width;
    opacity: mouseArea.pressed ? 0.7 : 1;

    Rectangle{
        anchors.fill: parent;
        color: mouseArea.pressed ? "#11ffffff" : "#00ffffff"
    }

    Column {
        id: logo;
        anchors.centerIn: parent;
        Image {
            width:Theme.iconSizeMedium
            height:width
            anchors.horizontalCenter: parent.horizontalCenter;
            source: iconSource;

        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter;
            font.pixelSize: constant.fontXXSmall;
            color: constant.colorLight;
            text: root.title;
        }
    }
    MouseArea {
        id: mouseArea;
        anchors.fill: parent;
        onClicked: root.clicked();
    }
}
