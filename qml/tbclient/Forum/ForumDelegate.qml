import QtQuick 2.0
import "../Component"

AbstractItem {
    id: root;
    property string border : ""
    implicitHeight: contentCol.height + constant.paddingLarge*2+16;
    onClicked: {
        var prop = { threadId: id, title: title };
        signalCenter.enterThread(prop);
    }

    Column {
        id: contentCol;
        anchors {
            left: root.paddingItem.left;
            right: root.paddingItem.right;
            top: root.paddingItem.top;
        }
        spacing: constant.paddingSmall;
        Item {
            width: parent.width;
            height: childrenRect.height;
            Text {
                
                font.pixelSize: 18;
                color: constant.colorMid;
                text: author;
            }
            Row {
                anchors.right: parent.right;
                spacing: 4;
                Image {
                    asynchronous: true;
                    enabled: is_good;
                    visible: enabled;
                    source: enabled ? "../gfx/icon_elite"+constant.invertedString : "";
                }
                Image {
                    asynchronous: true;
                    enabled: is_top;
                    visible: enabled;
                    source: enabled ? "../gfx/icon_top"+constant.invertedString : "";
                }
            }
        }
        Text {
            id:xtitle
            width: parent.width;
            text: title;
            color: constant.colorLight;
            //font.pixelSize: constant.fontXSmall;
            font.pixelSize: constant.fontXSmall;
            wrapMode: Text.WrapAnywhere;
            textFormat: Text.PlainText;
            elide: Text.ElideRight;
            maximumLineCount: 1;
        }
        Row {
            visible: tbsettings.showAbstract;
            anchors.horizontalCenter: parent.horizontalCenter;
            opacity:0.8;
            Text {
                width: contentCol.width - thumbnail.width;
                visible: text != "";
                anchors.verticalCenter: parent.verticalCenter;
                text: model.abstract;
                color: constant.colorMid;
                font.pixelSize: constant.fontXXSmall
                
                wrapMode: Text.WrapAnywhere;
                textFormat: Text.PlainText;
                elide: Text.ElideRight;
                maximumLineCount: 2;
                //maximumLineCount: thumbnail.enabled ? 2 : 1;
            }
            Image {
                id: thumbnail;
                asynchronous: true;
                enabled: source != "";
                visible: enabled;
                //width: enabled ? constant.thumbnailSize : 0;
                width: enabled ? 80 : 0;
                height: width;
                source: picUrl;
                fillMode: Image.PreserveAspectCrop;
                clip: true;
            }
        }
    }
    Text {
        anchors {
            left: parent.left;
            bottom: parent.bottom;
            bottomMargin: constant.paddingMedium;
            leftMargin: constant.paddingLarge
        }
        text: reply_show;
        font.pixelSize: constant.fontXXSmall-4;
        
        color: constant.colorMid
    }
    Row {
        anchors {
            right: parent.right;
            bottom: parent.bottom;
            margins: constant.paddingMedium;
        }
        Image {
            width:24;height:20;
            asynchronous: true;
            opacity:0.5;
            source: "../gfx/btn_icon_comment_n"+constant.invertedString;
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter;
            text: reply_num;
            font.pixelSize: constant.fontXXSmall-4;
            
            color: constant.colorMid
        }
    }
}
