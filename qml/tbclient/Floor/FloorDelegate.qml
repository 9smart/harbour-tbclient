import QtQuick 2.0
import "../Component"

AbstractItem {
    id: root;

    implicitHeight: contentCol.height + constant.paddingLarge*2;

    Column {
        id: contentCol;
        anchors {
            left: root.paddingItem.left; right: root.paddingItem.right;
            top: root.paddingItem.top;
        }
        spacing: constant.paddingMedium;
        Item {
            width: parent.width; height: childrenRect.height;
            Text {
                font.pixelSize: constant.fontXXSmall;

                color: constant.colorMid;
                text: author
            }
            Text {
                anchors.right: parent.right;
                font.pixelSize: constant.fontXXSmall;

                color: constant.colorMid;
                text: time;
            }
        }
        Text {
            width: parent.width;
            wrapMode: Text.Wrap;
            //textFormat: format;
            text: content;
            //font.pixelSize: tbsettings.fontSize;
            font.pixelSize: constant.fontXSmall;
            color: constant.colorLight;
            onLinkActivated: signalCenter.linkClicked(link);
        }
        Loader {
            width: parent.width;
            property string text: voiceMd5;
            property int format: voiceDuration;
            source: text ? "../Thread/AudioDelegate.qml" : "";
        }
    }
}
