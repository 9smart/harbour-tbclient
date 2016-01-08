import QtQuick 2.0
import "../Base"
import "../../js/Utils.js" as Utils

Item {
    id: root;
    height: constant.graphicSizeMedium;

    property bool isLoading: bheight==audioWrapper.currentMd5 && audioWrapper.loading;
    property bool isPlaying: bheight==audioWrapper.currentMd5 && audioWrapper.playing;

    Rectangle {
        id: icon;
        anchors.horizontalCenter: parent.horizontalCenter;
        height: parent.height;
        width: root.width / 2;
        //border { left: 20; top: 20; right: 20; bottom: 20; }
        radius:5;
        border.width: 1;
        border.color: "#428883";
        color: isPlaying?"#88da251c":(mouseArea.pressed ? "#88000000" : "#88bbbbbb")
    }

    Image {
        anchors {
            left: icon.left; leftMargin: constant.paddingLarge;
            verticalCenter: parent.verticalCenter;
        }
        asynchronous: true;
        source: "../gfx/icon_thread_voice"+constant.invertedString;
    }

    Text {
        anchors {
            right: icon.right; rightMargin: constant.paddingLarge*2;
            verticalCenter: parent.verticalCenter;
        }
        text: Utils.milliSecondsToString(isPlaying?(/*format-*/audioWrapper.position):format);
        font.pixelSize: constant.fontXSmall;
        color: isLoading ? constant.colorMid : constant.colorLight;
    }

    MouseArea {
        id: mouseArea;
        anchors.fill: icon;
        enabled: !isLoading;
        onClicked: audioWrapper.playMp3Audio(bwidth,bheight);
    }
}
