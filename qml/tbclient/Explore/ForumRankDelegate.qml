import QtQuick 2.0
import "../Component"
import "../Base"

AbstractItem {
    id: root;

    onClicked: signalCenter.enterForum(forum_name);

    implicitHeight: constant.thumbnailSize;

    Image {
        id: logo;
        asynchronous: true;
        anchors {
            left: root.left;
            top: root.top;
            bottom: root.bottom;
            margins: 5;
        }
        width: height;
        source: model.avatar;
    }
    Image {
        id: subItemIcon;
        anchors {
            right: root.paddingItem.right;
            verticalCenter: parent.verticalCenter;
        }
        source: "image://theme/icon-m-page-up"//+(theme.inverted?"-inverse":"");
    }
    Column {
        anchors {
            left: logo.right; leftMargin: constant.paddingMedium;
            right: subItemIcon.left;
            verticalCenter: parent.verticalCenter;
        }
        Text {
            width: parent.width;
            elide: Text.ElideRight;
            font: constant.labelFont;
            color: constant.colorLight;
            text: forum_name;
        }
        Row {
            width: parent.width;
            Text {
                width: parent.width / 2;
                elide: Text.ElideRight;
                font.pixelSize: constant.fontXXSmall;
                color: constant.colorMid;
                text: qsTr("%1 members").arg(member_count);
            }
            Text {
                width: parent.width / 2;
                elide: Text.ElideRight;
                font.pixelSize: constant.fontXXSmall;
                color: constant.colorMid;
                text: qsTr("%1 posts").arg(thread_count);
            }
        }
        Text {
            width: parent.width;
            elide: Text.ElideRight;
            font.pixelSize: constant.fontXXSmall;
            color: constant.colorMid;
            text: slogan;
            visible: slogan != "";
        }
    }
}
