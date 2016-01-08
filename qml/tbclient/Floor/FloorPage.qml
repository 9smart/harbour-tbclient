import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../Base"
import "../../js/main.js" as Script

MyPage {
    id: page;

    title: qsTr("Subfloor");

    property string postId;
    property string spostId;
    property string threadId;

    property int ffuck: 0;
    onPostIdChanged: ffuck++;
    onSpostIdChanged: ffuck++;
    onThreadIdChanged: ffuck+=2;
    onFfuckChanged: if(ffuck>2){
                        internal.getlist();
                    }

    // 0 -- normal, 1 -- major, 2 -- minor
    property int managerGroup: 0;

    /*tools: ToolBarLayout {
        BackButton {}
        ToolIcon {
            platformIconId: "toolbar-refresh"
            onClicked: internal.getlist();
        }
        ToolIcon {
            enabled: internal.post != null;
            platformIconId: "toolbar-edit";
            onClicked: toolsArea.state = "Input";
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu";
            onClicked: internal.openMenu();
        }
    }*/

    Connections {
        target: signalCenter;
        onVcodeSent: if (caller === page) internal.addPost(vcode, vcodeMd5);
    }

    QtObject {
        id: internal;

        property variant forum: ({});
        property variant thread: ({});
        property variant post: null;
        property variant menu: null;
        property variant jumper: null;
        property variant floorMenu: null;

        property int currentPage: 1;
        property int pageSize: 10;
        property int totalPage: 0;
        property int totalCount: 0;

        function getlist(option){
            option = option || "renew";
            var opt = { page: internal, model: view.model, kz: threadId }

            if (post != null) opt.pid = post.id;
            else if (postId != "") opt.pid = postId;
            else if (spostId != "") opt.spid = spostId;

            if (option === "renew"){
                opt.renew = true;
                opt.pn = 1;
            } else if (option === "next"){
                opt.pn = currentPage + 1;
            } else if (option === "jump"){
                opt.renew = true;
                opt.pn = currentPage;
            }
            loading = true;
            var s = function(){ loading = false; }
            var f = function(err){signalCenter.showMessage(err); loading = false; }
            Script.getFloorPage(opt, s ,f);
        }
        function openMenu(){
            if (menu == null)
                menu = menuComp.createObject(page);
            menu.open();
        }
        function jumpToPage(){
            if (!jumper){
                jumper = Qt.createComponent("../Dialog/PageJumper.qml").createObject(page);
                var jump = function(){
                    currentPage = jumper.currentPage;
                    getlist("jump");
                }
                jumper.accepted.connect(jump);
            }
            jumper.totalPage = totalPage;
            jumper.currentPage = currentPage;
            jumper.open();
        }

        function addPost(vcode, vcodeMd5){
            var opt = {
                tid: thread.id,
                fid: forum.id,
                quote_id: post.id,
                content: toolsArea.text,
                kw: forum.name
            }
            if (vcode){
                opt.vcode = vcode;
                opt.vcode_md5 = vcodeMd5;
            }
            loading = true;
            var s = function(){
                loading = false;
                signalCenter.showMessage(qsTr("Success"));
                getlist();
                toolsArea.text = "";
                toolsArea.state = "";
            }
            var f = function(err, obj){
                loading = false;
                signalCenter.showMessage(err);
                if (obj && obj.info && obj.info.need_vcode === "1"){
                    signalCenter.needVCode(page, obj.info.vcode_md5, obj.info.vcode_pic_url,
                                           obj.info.vcode_type === "4");
                }
            }
            Script.floorReply(opt, s, f);
        }

        function addStore(){
            var opt = { add: true, tid: threadId }
            opt.pid = post.id;
            var s = function(){ loading = false; signalCenter.showMessage(qsTr("Success")) }
            var f = function(err){ loading = false; signalCenter.showMessage(err); }
            loading = true;
            Script.setBookmark(opt, s, f);
        }

        function createMenu(index,smItem){
            if (!floorMenu)
                floorMenu = Qt.createComponent("FloorMenu.qml").createObject(view);
            floorMenu.index = index;
            floorMenu.model = view.model.get(index);
            floorMenu.show(smItem);
        }

        function delPost(index){
            var execute = function(){
                var model = view.model.get(index);
                var opt = {
                    floor: true,
                    vip: managerGroup === 0,
                    word: forum.name,
                    fid: forum.id,
                    tid: thread.id,
                    pid: model.id
                }
                loading = true;
                var s = function(){
                    loading = false;
                    signalCenter.showMessage(qsTr("Success"));
                    view.model.remove(index);
                }
                var f = function(err){
                    loading = false;
                    signalCenter.showMessage(err);
                }
                Script.delpost(opt, s, f);
            }
            signalCenter.createQueryDialog(qsTr("Warning"),
                                           qsTr("Delete this post?"),
                                           qsTr("OK"),
                                           qsTr("Cancel"),
                                           execute);
        }
    }

    PageHeader {
        id: viewHeader;
        title: internal.post ? qsTr("Floor %1").arg(internal.post.floor)
                             : page.title;
        //onClicked: view.scrollToTop();
    }

    ListView {
        id: view;
        //property Item floorMenu
        anchors {
            left: parent.left; right: parent.right;
            top: viewHeader.bottom; bottom: toolsArea.top;
        }
        cacheBuffer: height * 3;
        model: ListModel {}
        header: internal.post ? headerComp : null;
        delegate: Item {
            id: myListItem
            property bool menuOpen: internal.floorMenu != null && internal.floorMenu.parent === myListItem
            width: view.width
            height: menuOpen ? internal.floorMenu.height + contentItem.height : contentItem.height

            FloorDelegate {
                id: contentItem
                width: view.width
                onPressAndHold: {
                    //console.log(menuOpen)
                    internal.createMenu(index,myListItem);//contextMenu.show(myListItem);

                    console.log(internal.floorMenu.parent == myListItem)
                }
                onClicked: {
                    toolsArea.text = qsTr("Reply to %1 :").arg(author);
                    toolsArea.cursorPosition = toolsArea.text.length;
                    toolsArea.state = "Input";
                }
            }
        }
        footer: FooterItem {
            visible: view.count > 0;
            enabled: !loading && internal.currentPage < internal.totalPage;
            onClicked: internal.getlist("next");
        }

        Component {
            id: headerComp;
            FloorHeader {
                post: internal.post;
                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        toolsArea.text = "";
                        toolsArea.cursorPosition = toolsArea.text.length;
                        toolsArea.state = "Input";
                    }
                }
            }
        }

        Component {
            id: contextMenuComponent
            ContextMenu {
                id: root;

                property int index: -1;
                property variant model: null;

                MenuItem {
                    text: qsTr("Copy content");
                    onClicked: signalCenter.copyToClipboard(model.content);
                }
                MenuItem {
                    text: qsTr("Delete this post");
                    visible: model != null && (managerGroup !== 0
                                               ||model.authorId === tbsettings.currentUid
                                               ||internal.thread.author.id === tbsettings.currentUid);
                    onClicked: internal.delPost(root.index);
                }
                MenuItem {
                    text: qsTr("Commit to prison");
                    visible: managerGroup !== 0;
                    onClicked: {
                        var prop = {
                            fname: internal.forum.name,
                            fid: internal.forum.id,
                            tid: internal.thread.id,
                            username: model.author,
                            majorManager: managerGroup === 1
                        }
                        signalCenter.commitPrison(prop);
                    }
                }
            }
        }
    }

    VerticalScrollDecorator { flickable: view; }

    ToolsArea {
        id: toolsArea;
    }

    onStatusChanged: {
        if (status === PageStatus.Deactivating){
            audioWrapper.stop();
            //toolsArea.state = "";
        }
    }
}
