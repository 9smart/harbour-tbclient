import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../Base"

Item {
    id: root;

    signal likeButtonClicked;
    signal signButtonClicked;
    width: page.width;
    //height: contentCol.height + constant.paddingLarge;
    height: contentCol.height + constant.paddingMedium*2;
    Image {
        id: icon;
        anchors {
            left: parent.left;
            top: parent.top;
            //bottom: parent.bottom;
            margins: constant.paddingMedium;
        }
        height: contentCol.implicitHeight;
        width: contentCol.implicitHeight;
        asynchronous: true;
        source: internal.forum.avatar||"";
    }
    Column {
        id: contentCol;
        anchors {
            left: icon.right;
            right: parent.right;
            top: parent.top;
            topMargin: constant.paddingMedium;
            leftMargin: constant.paddingMedium;
        }
        Text {
            font.pixelSize: constant.fontMedium;
            color: constant.colorLight;
            text: (internal.forum.name + "吧")||"";
        }
        Text {
            font.pixelSize: constant.fontXXSmall;
            color: constant.colorMid;
            text: qsTr("members:<b>%1</b> , posts:<b>%2</b>")
            .arg(internal.forum.member_num).arg(internal.forum.post_num);
            //textFormat: Text.StyledText;
        }
        Row {
            id:levelrow
            width: (contentCol.width-constant.paddingMedium)/2
            height: constant.graphicSizeSmall+constant.paddingMedium
            spacing: constant.paddingSmall;
            ProgressBar {
                visible: internal.isLike;
                anchors.verticalCenter: parent.bottom;
                anchors.verticalCenterOffset: -5;
                Row{
                    id: msg_level;
                    spacing: constant.paddingMedium;
                    Image {
                        id: img_level;
                        height: constant.fontXXSmall*1.5
                        width: height*1.7
                        anchors.verticalCenter: parent.verticalCenter;
                        source: "../gfx/icon_grade_lv%1.png".arg(internal.forum.level_id);

                    }
                    Text {
                        id: text_level;
                        anchors.verticalCenter: parent.verticalCenter;
                        font.pixelSize: constant.fontXXSmall/4*3;
                        color: constant.colorMid;
                        text: ""+internal.forum.level_name+"\n"+internal.forum.cur_score+"/"+internal.forum.levelup_score;
                    }
                }
                width: (contentCol.width-constant.paddingMedium)/2;
                minimumValue: 0;
                leftMargin: 0;
                rightMargin: 0;
                maximumValue: internal.forum.levelup_score||0;
                value: internal.forum.cur_score||0;
            }
            ForumHeaderButton{
                width: visible ? (contentCol.width-constant.paddingMedium)/2:0;
                height: constant.graphicSizeSmall
                visible: !internal.isLike;
                anchors.bottom: parent.bottom;
                iconSource: "/gfx/icon_s_add.png"
                text:"关注"
                releasedcolor: "#44f68686"
                pressedcolor: "#44ac5e5e"
                textcolor: "#ffffff"
                font.pixelSize: constant.fontXXSmall;
                font.bold: true;
                onClicked: root.likeButtonClicked();
            }

            ForumHeaderButton{
                width: visible ? (contentCol.width-constant.paddingMedium)/2:0;
                height: constant.graphicSizeSmall
                visible: !internal.hasSigned;
                anchors.bottom: parent.bottom;
                iconSource: "/gfx/icon_s_sign.png"
                text:"签到"
                releasedcolor: "#445793ed"
                pressedcolor: "#444777be"
                textcolor: "#ffffff"
                font.pixelSize: constant.fontXXSmall;
                font.bold: true;
                onClicked: root.signButtonClicked();
            }
            ForumHeaderButton{
                width: visible ? (contentCol.width-constant.paddingMedium)/2:0;
                height: constant.graphicSizeSmall
                visible: internal.hasSigned;
                anchors.bottom: parent.bottom;
                iconSource: "/gfx/icon_s_ok.png"
                text: qsTr("%1 days").arg(internal.signDays);
                releasedcolor: "#448cbaff"
                pressedcolor: "#448cbaff"
                textcolor: "#ffffff"
                font.pixelSize: constant.fontXXSmall;
                font.bold: true;
            }
        }
    }
    Rectangle {
        anchors{
            left:parent.left;
            bottom: parent.bottom;
        }
        color: "#ccffffff"
        width: parent.width; height: 1;
    }
}
