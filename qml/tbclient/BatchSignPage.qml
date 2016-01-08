import QtQuick 2.0
import Sailfish.Silica 1.0
import "Component"
import "Base"
import "../js/main.js" as Script

MyPage {
    id: page;

    title: qsTr("One-click sign");

    QtObject {
        id: internal;

        property bool canSign: signedCount < view.count;
        property bool signing: false;
        property int signedCount: 0;
        property variant info: null;

        function getlist(){
            var opt = { page: internal, model: view.model };
            var s = function(){ loading = false; }
            var f = function(err){ loading = false; signalCenter.showMessage(err); }
            loading = true;
            Script.getForumListForSign(opt, s, f)
        }

        function sign(){
            var list = [];
            for (var i=0; i<view.count; i++){
                var o = view.model.get(i);
                if (!o.hasSigned){
                    list.push(o.forum_id);
                }
            }
            if (list.length > 0){
                var opt = { forum_ids: list };
                var s = function(obj){
                    if (Array.isArray(obj.info)){
                        obj.info.forEach(function(value){
                                             if (value.error.err_no === "0"){
                                                 for (var i=0; i<view.count; i++){
                                                     if (view.model.get(i).forum_id === value.forum_id){
                                                         var prop = {
                                                             cont_sign_num: value.sign_day_count,
                                                             hasSigned: value.signed === "1"
                                                         }
                                                         view.model.set(i, prop);
                                                         signalCenter.forumSigned(value.forum_id);
                                                         return;
                                                     }
                                                 }
                                             }
                                         });
                        signedCount = view.count;
                    }
                    signing = false;
                };
                var f = function(err){
                    signing = false; signalCenter.showMessage(err);
                }
                signing = true;
                Script.batchSign(opt, s, f);
            }
        }
    }

    PageHeader {
        id: viewHeader;
        title: page.title;
        //onClicked: view.scrollToTop();
    }

    SilicaListView {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        model: ListModel {}
        header: headerComp;
        delegate: deleComp;
        footer: footerComp;
        cacheBuffer: view.height * 5;
        Component {
            id: headerComp;
            Rectangle {
                id: root;
                width: view.width;
                height: contentCol.height + Theme.paddingLarge;
                color: "#88354050";

                Column {
                    id: contentCol;
                    width: parent.width;
                    anchors { top: parent.top; topMargin: Theme.paddingLarge; }
                    spacing: Theme.paddingLarge;
                    Image {
                        property string stateString: signBtnMA.pressed?"d":"n";
                        anchors.horizontalCenter: parent.horizontalCenter;
                        source: "gfx/bg_all_sign_%1.png".arg(stateString);
                        width:sourceSize.width/540*Screen.width;
                        height: width;
                        Column {
                            anchors.centerIn: parent;
                            spacing: Theme.paddingSmall;
                            Image {
                                anchors.horizontalCenter: parent.horizontalCenter;
                                source: "gfx/icon_all_sign_%1.png".arg(parent.parent.stateString);
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter;
                                font.pixelSize: constant.fontXXSmall;
                                font.weight: Font.Light;
                                color: "white";
                                text: internal.info ? internal.canSign ? qsTr("Start") : qsTr("Completed") : "";
                            }
                        }
                        MouseArea {
                            id: signBtnMA;
                            anchors.fill: parent;
                            enabled: internal.canSign;
                            onClicked: internal.sign();
                        }
                    }
                    Text {
                        width: parent.width;
                        wrapMode: Text.Wrap;
                        horizontalAlignment: Text.AlignHCenter;
                        font.pixelSize: constant.fontXXSmall;
                        font.weight: Font.Light;
                        color: "white";
                        text: {
                            var i = internal.info;
                            if (i){
                                return i.text_pre+i.text_color+i.text_mid+"\n"+i.text_suf;
                            } else {
                                return "";
                            }
                        }
                    }
                    Rectangle {
                        width: parent.width;
                        height: headingLeftLabel.height + Theme.paddingMedium*2;
                        color: "#22ffffff"
                        Text {
                            id: headingLeftLabel;
                            anchors {
                                left: parent.left; leftMargin: Theme.paddingMedium;
                                verticalCenter: parent.verticalCenter;
                            }
                            text: internal.info ? internal.info.title : "";
                            font.pixelSize: constant.fontXXSmall;
                            font.weight: Font.Light;
                            color: Theme.primaryColor;
                        }
                        Text {
                            anchors {
                                right: parent.right; rightMargin: Theme.paddingMedium;
                                verticalCenter: parent.verticalCenter;
                            }
                            text: qsTr("Signed: %1/%2").arg(internal.signedCount).arg(view.count);
                            font.pixelSize: constant.fontXXSmall;
                            font.weight: Font.Light;
                            color: Theme.primaryColor;
                        }
                    }
                }
            }
        }

        Component {
            id: deleComp;
            AbstractItem {
                id: root;
                Image {
                    id: avatarImg;
                    asynchronous: true;
                    anchors {
                        left: root.left;
                        top: root.top;
                        bottom: root.bottom;
                        margins: 5;
                    }
                    width: height;
                    source: avatar;
                }
                Column {
                    id: contentCol;
                    anchors {
                        left: avatarImg.right; leftMargin: Theme.paddingLarge;
                        right: root.paddingItem.right;
                        verticalCenter: parent.verticalCenter;
                    }
                    Text {
                        width: contentCol.width;
                        font.pixelSize: constant.fontXSmall;
                        color: Theme.highlightColor;
                        text: forum_name + "  " + qsTr("Lv.%1").arg(user_level);
                        elide: Text.ElideRight;
                    }
                    Row {
                        spacing: Theme.paddingMedium;
                        Text {
                            font.pixelSize: constant.fontXXSmall;
                            font.weight: Font.Light;
                            color: Theme.highlightColor;
                            text: qsTr("Exp");
                        }
                        Text {
                            font.pixelSize: constant.fontXXSmall;
                            font.weight: Font.Light;
                            color: Theme.primaryColor;
                            text: user_exp + "/" + need_exp;
                        }
                    }
                }
                Loader {
                    anchors {
                        right: parent.right; rightMargin: Theme.paddingSmall;
                        verticalCenter: parent.verticalCenter;
                    }
                    sourceComponent: hasSigned ? signedInfo : undefined;
                    Component {
                        id: signedInfo;
                        Text {
                            id: infoText;
                            anchors.centerIn: parent;
                            font.pixelSize: constant.fontXXSmall;
                            font.weight: Font.Light;
                            color: Theme.highlightColor;
                            text: qsTr("Signed %1 days").arg(cont_sign_num);
                        }
                    }
                }
            }
        }

        Component {
            id: footerComp;
            Item {
                id: root;
                visible: internal.info ? view.count >= internal.sign_max_num : false;
                width: view.width;
                height: visible ? contentText.height + Theme.paddingLarge*2 : 0;
                Text {
                    id: contentText;
                    anchors {
                        left: parent.left; right: parent.right; top: parent.top;
                        margins: Theme.paddingLarge;
                    }
                    wrapMode: Text.Wrap;
                    horizontalAlignment: Text.AlignHCenter;
                    font.pixelSize: Theme.fontSizeMedium;
                    color: Theme.primaryColor;
                    text: internal.info ? internal.info.num_notice : "";
                }
            }
        }
    }

    VerticalScrollDecorator { flickable: view; }

    Rectangle {
        id: bgRect;
        z: 100;
        anchors.fill: parent;
        color: "#A0000000";
        visible: internal.signing;
        Column {
            anchors.centerIn: parent;
            spacing: Theme.paddingSmall;
            BusyIndicator {
                anchors.horizontalCenter: parent.horizontalCenter;
                running: true;
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter;
                font.pixelSize: Theme.fontSizeLarge;
                color: "white";
                text: qsTr("Signing");
            }
        }
        MouseArea {
            anchors.fill: parent;
        }
    }

    Component.onCompleted: internal.getlist();
}
