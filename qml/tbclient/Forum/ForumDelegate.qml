import QtQuick 2.0
import "../Component"
import "../Base"

AbstractItem {
    id: root;
    property string border : ""
    implicitHeight: contentCol.height + constant.paddingMedium*2 + constant.fontXSmall;
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
        spacing: constant.paddingMedium;
        Item {
            width: parent.width;
            height: childrenRect.height;
            Text {
                id:xtitle
                anchors{
                    left:parent.left;
                    right:xsign.left;
                }
                color: constant.colorLight;
                font.pixelSize: constant.fontXSmall;
                wrapMode: Text.WrapAnywhere;
                textFormat: Text.PlainText;
                elide: Text.ElideRight;
                maximumLineCount: 1;
                text: title;
            }
            Row {
                id:xsign
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

        Row {
            visible: tbsettings.showAbstract;
            anchors.horizontalCenter: parent.horizontalCenter;
            //opacity:0.8;
            Text {
                width: contentCol.width - thumbnail.width;
                //visible: text != "";
                //anchors.verticalCenter: parent.verticalCenter;
                text: model.abstract;
                color: constant.colorSecondaryLight//constant.colorMid;
                font.pixelSize: constant.fontXSmall
                lineHeight:1.2
                wrapMode: Text.WrapAnywhere;
                textFormat: Text.PlainText;
                elide: Text.ElideRight;
                //maximumLineCount: 2;
                maximumLineCount: thumbnail.enabled ? Math.floor(constant.thumbnailSize/constant.fontXXSmall) : 2;
            }
            Image {
                id: thumbnail;
                asynchronous: true;
                enabled: source != "";
                visible: enabled;
                width: enabled ? constant.thumbnailSize : 0;
                height: width;
                source: picUrl;
                fillMode: Image.PreserveAspectCrop;
                clip: true;
            }
        }
    }
//    Text {

//        font.pixelSize: 18;
//        color: constant.colorMid;
//        text: author;
//    }
    Text {
        anchors {
            left: parent.left;
            bottom: parent.bottom;
            bottomMargin: constant.paddingMedium;
            leftMargin: constant.paddingMedium
        }
        text: "楼主: "+author+" / 最后回复: "+reply_show;
        font.pixelSize: constant.fontXXSmall*0.8;
        
        color: constant.colorMarginLine//constant.colorMid
    }
    Row {
        anchors {
            right: parent.right;
            bottom: parent.bottom;
            margins: constant.paddingMedium;
        }
        Image {
            anchors.verticalCenter: parent.verticalCenter;
            asynchronous: true;
            height:constant.fontXSmall;
            width:height*1.2;
            source: "../gfx/btn_icon_comment_n"+constant.invertedString;
        }
        Text {
            anchors.bottom: parent.bottom;
            verticalAlignment: Text.AlignVCenter
            text: reply_num;
            font.pixelSize: constant.fontXXSmall/1.2;
            color: constant.colorMid
        }
    }
}
