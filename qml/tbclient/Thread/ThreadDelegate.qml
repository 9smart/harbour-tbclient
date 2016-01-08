import QtQuick 2.0
import "../Component"
import "../Base"

AbstractItem {
    id: root;

    implicitHeight: contentCol.height + constant.paddingLarge;

    Column {
        id: contentCol;
        width: parent.width;
        spacing: constant.paddingMedium;
        Item {
            width: parent.width;
            height: constant.graphicSizeMedium;

            Image {
                anchors{
                    left:parent.left;
                    top:parent.top;
                    leftMargin: constant.paddingMedium;
                    topMargin: constant.paddingSmall;
                }

                id: avatar;
                width: constant.graphicSizeMedium;
                height: constant.graphicSizeMedium;
                sourceSize: constant.sizeMedium;
                source: authorPortrait;
                asynchronous: true;
                MouseArea {
                    anchors.fill: parent;
                    onClicked: signalCenter.linkClicked("at:"+authorId);
                }
            }
            Text {
                id:authorMessage
                anchors {
                    left: avatar.right;
                    leftMargin: constant.paddingMedium;
                    top:parent.top;
                }
                text: authorName;
                font.pixelSize: constant.fontXXSmall;
                
                color: constant.colorMid;
            }

            Image {
                asynchronous: true;
                anchors{
                    left:authorMessage.right;
                    verticalCenter: authorMessage.verticalCenter;
                    leftMargin: constant.paddingMedium;
                }
                source: "../gfx/icon_grade_lv"+authorLevel+".png";
            }
            Text {
                anchors {
                    top: authorMessage.bottom;
                    left: authorMessage.left;
                    rightMargin: constant.paddingSmall;
                }
                text: time;
                font.pixelSize: constant.fontXXSmall;
                
                color: constant.colorMid;
            }

            Text {
                anchors.right: parent.right;
                text: floor + "#";
                font.pixelSize: constant.fontXSmall;
                
                color: constant.colorMid;
            }
        }
        Repeater {
            model: content;
            Loader {
                anchors {
                    left: parent.left; right: parent.right;
                    margins: constant.paddingLarge;
                }
                source: type + "Delegate.qml";
            }
        }
    }
    Row {
        anchors {
            right: parent.right;
            bottom: parent.bottom;
            margins: constant.paddingSmall;
        }
        visible: floor !== "1";
        Image {
            asynchronous: true;
            height:constant.fontXSmall;
            width:height*1.2;
            source: "../gfx/btn_icon_comment_n"+constant.invertedString;
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter;
            text: sub_post_number;
            font.pixelSize: constant.fontXXSmall;
            
            color: constant.colorMid;
        }
    }
}
