import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Base"

Item {
    id: root;

    property int bh: Math.min(300, bheight);
    property int bw: Math.min(300, bwidth);
    implicitHeight: bh;

    //var ww = Math.min(200, w), hh = Math.min(h * ww/w, 200);

    MouseArea {
        anchors.fill: img;
        onClicked: {
            signalCenter.viewImage(text,bheight,bwidth)//(format);
            console.log("---"+bwidth+"---"+bheight)
        }
    }

    Image {
        id: img;
        anchors.horizontalCenter: root.horizontalCenter;
        //width: Screen.width*3/4;
        width: bw;
        height: parent.height;
        fillMode: Image.PreserveAspectFit;
        sourceSize.width: bw;
        source: text;
        asynchronous: true;
    }

    Image {
        anchors.centerIn: img;
        sourceSize: constant.sizeMedium;
        source: img.status === Image.Ready ? "" : "../gfx/image_default"+constant.invertedString;
        asynchronous: true;
    }
}
