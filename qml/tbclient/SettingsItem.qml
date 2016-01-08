import QtQuick 2.0
import Sailfish.Silica 1.0
import "Component"
import "Base"

Item {
    id: listItem

    signal clicked
    signal pressAndHold
    property alias pressed: mouseArea.pressed

    property string title;
    property int titleSize: 26
    property int titleWeight: Font.Bold
    property color titleColor: "#ffffff" // theme.inverted ? "#ffffff" : "#282828"

    property string subtitle;
    property int subtitleSize: 22
    property int subtitleWeight: Font.Light
    property color subtitleColor:"#d2d2d2"// theme.inverted ? "#d2d2d2" : "#505050"

    property string iconSource;
    property bool subItemIconVisible: false;

    height: 88
    width: parent.width

    Row {
        id: contentRow;
        anchors {
            fill: parent;
            leftMargin: 18;
            rightMargin: 18;
        }
        spacing: 18

        Image {
            anchors.verticalCenter: parent.verticalCenter
            visible: listItem.iconSource != "";
            width: 64
            height: 64
            sourceSize: Qt.size(64, 64);
            source: listItem.iconSource;
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter

            Label {
                id: mainText
                text: listItem.title;
                //font.weight: listItem.titleWeight
                font.pixelSize: listItem.titleSize
                color: listItem.titleColor
            }

            Label {
                id: subText
                text: listItem.subtitle;
                font.weight: listItem.subtitleWeight
                font.pixelSize: listItem.subtitleSize
                color: listItem.subtitleColor

                visible: text != ""
            }
        }
    }
//    Image {
//        id: subItemIcon;
//        anchors {
//            right: parent.right; rightMargin: 18;
//            verticalCenter: parent.verticalCenter;
//        }
//        source: "image://theme/icon-m-common-drilldown-arrow"+(true?"-inverse":"");
//        visible: listItem.subItemIconVisible;
//    }

    Separator{}

    MouseArea {
        id: mouseArea;
        anchors.fill: parent
        onClicked: {
            listItem.clicked();
        }
        onPressAndHold: {
            listItem.pressAndHold();
        }
    }
}
