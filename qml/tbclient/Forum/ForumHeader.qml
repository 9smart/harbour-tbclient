import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root;

    signal likeButtonClicked;
    signal signButtonClicked;
    width: page.width;
    //height: contentCol.height + constant.paddingLarge;
    height: contentCol.implicitHeight + constant.paddingLarge*2;
    Image {
        id: icon;
        anchors {
            left: parent.left;
            top: parent.top;
            //bottom: parent.bottom;
            margins: constant.paddingLarge;
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
            topMargin: constant.paddingLarge;
            leftMargin: constant.paddingLarge;
        }
        Text {
            font.pixelSize: constant.fontSmall;
            color: constant.colorLight;
            text: internal.forum.name||"";
        }
        Text {
            font.pixelSize: constant.fontXXSmall;
            color: constant.colorMid;
            text: qsTr("members:<b>%1</b> , posts:<b>%2</b>")
            .arg(internal.forum.member_num).arg(internal.forum.post_num);
            //textFormat: Text.StyledText;
        }
        Row {
            spacing: constant.paddingSmall;
            ProgressBar {
                visible: internal.isLike;
                anchors.verticalCenter: parent.bottom;
                anchors.verticalCenterOffset: -5;
                //height: msg_level.implicitHeight+constant.paddingMedium;
                Row{
                    id: msg_level;
                    Image {
                        id: img_level;
                        anchors.verticalCenter: text_level.verticalCenter;
                        source: "../gfx/icon_grade_lv%1.png".arg(internal.forum.level_id);

                    }
                    Text {
                        id: text_level;
                        font.pixelSize: constant.fontXXSmall;
                        color: constant.colorMid;
                        text: " "+internal.forum.level_name;
                    }
                    Text {
                        font.pixelSize: constant.fontXXSmall;
                        color: constant.colorMid;
                        text: "("+internal.forum.cur_score+"/"+internal.forum.levelup_score+")";
                    }
                }
                width: msg_level.implicitWidth;
                minimumValue: 0;
                leftMargin: 0;
                rightMargin: 0;
                maximumValue: internal.forum.levelup_score||0;
                value: internal.forum.cur_score||0;
            }

            Image {
                width: visible?111:0;
                height: 46
                visible: !internal.isLike;
                anchors.bottom: parent.bottom;
                //anchors.verticalCenter: parent.verticalCenter;
                sourceSize: Qt.size(width, height);
                source: "../gfx/btn_like_"+likeBtnMouseArea.stateString+constant.invertedString;
                MouseArea {
                    id: likeBtnMouseArea;
                    property string stateString: pressed ? "s" : "n";
                    anchors.fill: parent;
                    onClicked: root.likeButtonClicked();
                }
            }

            Image {
                width: visible?111:0;
                height: 46;
                visible: !internal.hasSigned;
                anchors.bottom: parent.bottom;
                //anchors.verticalCenter: parent.verticalCenter;
                sourceSize: Qt.size(width, height);
                source: "../gfx/btn_sign_"+signBtnMouseArea.stateString+constant.invertedString;
                BusyIndicator {
                    anchors.centerIn: parent;
                    running: true;
                    visible: internal.signing;
                }
                MouseArea {
                    id: signBtnMouseArea;
                    property string stateString: pressed||internal.signing ? "s" : "n";
                    anchors.fill: parent;
                    enabled: !internal.signing;
                    onClicked: root.signButtonClicked();
                }
            }
            Rectangle{
                width: signInfoText.paintedWidth + 20;
                height: 46;
                visible: internal.hasSigned;
                anchors.bottom: parent.bottom;
                color: "#88ffffff"
                radius:5;
                border.width: 1;
                border.color: "#428883";
                Text {
                    id: signInfoText;
                    anchors.centerIn: parent;
                    font.pixelSize: constant.fontXXSmall;
                    color: "red";
                    text: qsTr("Signed %1 days").arg(internal.signDays);
                }
            }
            Image {
                width: signInfoText.paintedWidth + 20;
                height: 46;
                visible: false//internal.hasSigned;
                anchors.bottom: parent.bottom;
                //anchors.verticalCenter: parent.verticalCenter;
                source: "../gfx/ico_sign"+constant.invertedString;
                smooth: true;
                Text {
                    //id: signInfoText;
                    anchors.centerIn: parent;
                    font.pixelSize: constant.fontXXSmall;
                    color: "red";
                    text: qsTr("Signed %1 days").arg(internal.signDays);
                }
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
