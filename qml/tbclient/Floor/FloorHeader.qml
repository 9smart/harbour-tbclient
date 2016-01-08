import QtQuick 2.0
import "../Base"
import "../../js/main.js" as Script

Item {
    id: root;

    property variant post;

    width: page.width;
    height: contentCol.height + constant.paddingLarge*2;

    Image {
        id: avatar;
        anchors {
            left: root.left; top: root.top;
            margins: constant.paddingLarge;
        }
        asynchronous: true;
        width: constant.graphicSizeMedium;
        height: constant.graphicSizeMedium;
        sourceSize: constant.sizeMedium;
        source: Script.getPortrait(tbsettings.showImage?post.author.portrait:"");
    }

    Column {
        id: contentCol;
        anchors {
            left: avatar.right; top: parent.top; right: parent.right;
            margins: constant.paddingLarge;
        }
        spacing: constant.paddingMedium;
        Row{
            Text {
                id:fauthor
                font.pixelSize: constant.fontXXSmall;
                
                color: constant.colorMid;
                text:  post.author.name + "  ";
            }
            Image {
                asynchronous: true;
                anchors{
                    verticalCenter: fauthor.verticalCenter;
                    leftMargin: constant.paddingMedium;
                }
                source: "../gfx/icon_grade_lv"+post.author.level_id+".png";
            }
        }
        MouseArea {
            id: contentMouseArea;
            width: parent.width;
            height: Math.min(contentLabel.height, constant.graphicSizeLarge+20);
            onHeightChanged: view.positionViewAtBeginning();
            clip: true;
            onClicked: state = state === "" ? "Expanded" : "";
            states: [
                State {
                    name: "Expanded";
                    PropertyChanges {
                        target: contentMouseArea; height: contentLabel.height;
                    }
                }
            ]
            transitions: [
                Transition {
                    PropertyAnimation { property: "height"; }
                }

            ]
            Text {
                id: contentLabel;
                width: parent.width;
                wrapMode: Text.WrapAnywhere;
                //font.pixelSize: tbsettings.fontSize;
                font.pixelSize: constant.fontXSmall;
                color: constant.colorLight;
                text: Script.BaiduParser.__parseFloorContent(post.content)[0];
            }
        }
        Item {
            width: parent.width; height: childrenRect.height;
            Text {
                font.pixelSize: constant.fontXXSmall;
                
                color: constant.colorMid;
                text: Qt.formatDateTime(new Date(Number(post.time+"000")), "yyyy-MM-dd hh:mm:ss");
            }
            Row {
                anchors.right: parent.right;
                Image {
                    asynchronous: true;
                    height:constant.fontXSmall;
                    width:height*1.2;
                    source: "../gfx/btn_icon_comment_n"+constant.invertedString;
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: internal.totalCount+"";
                    font.pixelSize: constant.fontXXSmall;
                    
                    color: constant.colorMid;
                }
            }
        }
    }
}
