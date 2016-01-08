import QtQuick 2.0
import "../Base"

Rectangle {
    id:root
    property color textcolor: "#666666"
    property color releasedcolor: "#ffffff"
    property color pressedcolor: "#dddddd"
    property string iconSource: ""
    property string text: ""
    property font font

    signal clicked;

    radius:5;
    color: mousearea.pressed ? pressedcolor:releasedcolor

    Row{
        id:row
        anchors.centerIn: parent
        height: parent.height
        spacing: constant.paddingMedium
        Image{
            id:ico
            anchors.verticalCenter: parent.verticalCenter;
            width: itxt.height;
            height: width
            source: "../"+iconSource;
        }
        Text{
            id:itxt
            anchors.verticalCenter: parent.verticalCenter;
            //anchors.verticalCenterOffset: 5
            color: textcolor
            text:root.text
            font:root.font
        }
    }


    MouseArea{
        id:mousearea
        anchors.fill: parent;
        onClicked: root.clicked();
    }
}

