import QtQuick 2.0
import Sailfish.Silica 1.0
Rectangle{
    id: icn;
    signal touched();
    property bool hasBorder: false;
    property string url: "";
    property string txt: "";
    property string col: "#00000000";
    height: Screen.width*0.11;
    width: icn.height*1.5;
    //scale: 1.2;
    color: "#00ffffff"
    Rectangle{
        id:bg
        visible: icn.hasBorder;
        anchors.centerIn: icn;
        anchors.margins: 10;
        color: icn.col;
        width: icn.height*5/6;
        height: icn.height*5/6;
        border{
            width: 1;
            color: "#88ffffff"
        }
        radius: bg.width/2;
    }
    Image {
        anchors.centerIn: icn;
        width: icn.height*2/3;
        height: icn.height*2/3;
        source: icn.url ? "../"+icn.url :"";
        MouseArea {
            anchors.fill: parent;
            onClicked: {
                icn.touched();
            }
        }
    }
    Text {
        anchors.centerIn: icn;
        height: lineHeight;
        font.pixelSize: icn.height*2/3-10;
        lineHeight: icn.height*2/3-10;
        color: "#ffbcc8de"
        text: icn.txt;
    }

}
