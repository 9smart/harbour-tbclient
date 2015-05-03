import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../Floor" as Floor
import "../../js/main.js" as Script

MyPage {
    id: page;

    property string threadId;
    property string forumName;
    onThreadIdChanged: internal.getlist();

    /*tools: ToolBarLayout {
        BackButton {}
        ToolIcon {
            platformIconId: "toolbar-refresh";
            enabled: view.currentItem != null;
            onClicked: view.currentItem.getlist();
        }
        ToolIcon {
            platformIconId: "toolbar-edit";
            enabled: view.currentItem != null;
            onClicked: toolsArea.state = "Input";
        }
        ToolIcon {
            platformIconId: "toolbar-directory-move-to"
            enabled: view.currentItem != null;
            onClicked: {
                var url = view.model.get(view.currentIndex).url;
                var path = tbsettings.imagePath + "/" + url.toString().split("/").pop();
                if (utility.saveCache(url, path)){
                    signalCenter.showMessage(qsTr("Image saved to %1").arg(path));
                } else {
                    utility.openURLDefault(url);
                }
            }
        }
    }*/

    QtObject {
        id: internal;

        property variant forum: null;
        property int picAmount;

        function getlist(option){
            option = option||"renew";
            var opt = {
                page: internal,
                model: view.model,
                tid: threadId,
                kw: forum?forum.name:forumName
            };
            if (option == "renew"){
                opt.pic_id = "";
                opt.renew = true;
            } else {
                opt.pic_id = view.model.get(view.count-1).pic_id;
            }
            loading = true;
            function s(){ loading = false; }
            function f(err){ loading = false; signalCenter.showMessage(err); }
            Script.getPicturePage(opt, s, f);
        }

        function addPost(vcode, vcodeMd5){
            var opt = {
                tid: threadId,
                fid: forum.id,
                quote_id: view.model.get(view.currentIndex).post_id,
                content: toolsArea.text,
                kw: forum.name
            }
            if (vcode){
                opt.vcode = vcode;
                opt.vcode_md5 = vcodeMd5;
            }
            var c = view.currentItem;
            c.loading = true;
            var s = function(){
                if (c) {
                    c.loading = false;
                    c.getlist();
                }
                signalCenter.showMessage(qsTr("Success"));
                toolsArea.text = "";
                toolsArea.state = "";
            }
            var f = function(err, obj){
                if (c) c.loading = false;
                signalCenter.showMessage(err);
                if (obj && obj.info && obj.info.need_vcode === "1"){
                    signalCenter.needVCode(page, obj.info.vcode_md5, obj.info.vcode_pic_url, obj.info.vcode_type === "4");
                }
            }
            Script.floorReply(opt, s, f);
        }
    }

    Connections {
        target: signalCenter;
        onVcodeSent: if (caller === page) internal.addPost(vcode, vcodeMd5);
    }

    PageHeader {
        id: viewHeader;
        title: (view.currentIndex+1)+"/"+internal.picAmount;
        //loadingVisible: page.loading || (view.currentItem != null && view.currentItem.loading);
    }

    ListView {
        id: view;
        focus: true;
        anchors { fill: parent; topMargin: viewHeader.height; }
        cacheBuffer: 1;
        highlightFollowsCurrentItem: true;
        highlightMoveDuration: 300;
        highlightRangeMode: ListView.StrictlyEnforceRange;
        preferredHighlightBegin: 0;
        preferredHighlightEnd: view.width;
        snapMode: ListView.SnapOneItem;
        orientation: ListView.Horizontal;
        boundsBehavior: Flickable.StopAtBounds;
        model: ListModel {}
        delegate: ThreadPictureDelegate{}
        onMovementEnded: {
            if (!atXEnd || loading) return;
            var d = view.model.get(view.count-1);
            if (!d) return;
            if (view.count >= internal.picAmount) return;
            internal.getlist("next");
        }
    }

    Floor.ToolsArea {
        id: toolsArea;
    }

    onStatusChanged: {
        if (status === PageStatus.Deactivating){
            toolsArea.state = "";
        }
    }
}
