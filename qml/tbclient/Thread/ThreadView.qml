import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../js/main.js" as Script
import "../Component"

MyPage {
    id: page;

    property string threadId;
    property variant thread: null;
    property variant forum: null;
    property variant user: null;

    property int currentPage: 0;
    property int totalPage: 0;
    property bool hasMore: false;
    property bool hasPrev: false;
    property int bottomPage: 0;
    property int topPage: 0;

    property bool isReverse: false;
    property bool isLz: false;
    property bool isArround: false;

    property bool fromBookmark: false;
    property bool isCollected: false;
    property string collectMarkPid;

    property variant threadMenu: null;

    property int privateFullPage: 0;
    onIsLzChanged: {
        if (isLz) privateFullPage = totalPage;
        else totalPage = privateFullPage;
    }

    function positionAtTop(){
        internal.openContextMenu();
    }
    function focus(){
        view.forceActiveFocus();
    }

    function getlist(option){
        option = option||"renew";
        var opt = {
            kz: threadId,
            model: view.model
        }
        if (isReverse) opt.r = 1;
        if (isLz) opt.lz = 1;
        if (option === "renew"){
            isArround = false;
            opt.renew = true;
            if (isReverse) opt.pn = totalPage;
        } else if (option === "next"){
            if (isReverse && bottomPage == 1 && !isArround){
                signalCenter.showMessage(qsTr("First page now"));
                return;
            }
            if (isArround){
                opt.arround = true;
                opt.pid = view.model.get(view.count-1).id;
            } else {
                if (hasMore)
                    opt.pn = isReverse ? bottomPage - 1
                                       : bottomPage + 1;
                else {
                    opt.pn = bottomPage;
                    opt.dirty = true;
                }
            }
        } else if (option === "prev"){
            if (!isReverse && topPage == 1 && !isArround){
                getlist("renew");
                return;
            }
            opt.insert = true;
            if (isArround){
                opt.arround = true;
                opt.r = 1;
                opt.pid = view.model.get(0).id;
            } else {
                if (hasPrev)
                    opt.pn = isReverse ? topPage + 1
                                       : topPage - 1;
                else {
                    opt.pn = topPage;
                    opt.dirty = true;
                }
            }
        } else if (option === "jump"){
            isArround = false;
            opt.renew = true;
            opt.pn = currentPage;
        } else if (/\b\d+\b/.test(option)){
            isArround = true;
            opt.renew = true;
            opt.arround = true;
            opt.pid = option;
        }

        if (fromBookmark && isArround)
            opt.st_type = "store_thread";

        var s = function(obj, modelAffected){
            loading = false;
            user = obj.user;
            thread = obj.thread;
            forum = obj.forum;
            currentPage = obj.page.current_page;
            totalPage = obj.page.total_page;
            isCollected = obj.thread.collect_status !== "0";
            collectMarkPid = obj.thread.collect_mark_pid;

            if (option === "renew"||option === "jump"||/\b\d+\b/.test(option)){
                hasMore = obj.page.has_more === "1";
                hasPrev = obj.page.has_prev === "1";
                bottomPage = currentPage;
                topPage = currentPage;
            } else if (option === "next"){
                hasMore = obj.page.has_more === "1";
                bottomPage = currentPage;
            } else if (option === "prev"){
                hasPrev = obj.page.has_prev === "1";
                topPage = currentPage;
                view.positionViewAtIndex(modelAffected, ListView.Visible);
            }
            if (modelAffected === 0)
                signalCenter.showMessage(qsTr("No more posts"));
        }
        var f = function(err){
            loading = false;
            signalCenter.showMessage(err);
        }
        loading = true;
        Script.getThreadPage(opt, s, f);
    }

    function addStore(pid){
        var opt = { add: true, tid: threadId }
        opt.status = isLz ? "1" : isReverse ? "2" : "0";
        opt.pid = pid || view.model.get(0).id;
        var s = function(){ loading = false; isCollected = true;
            collectMarkPid = opt.pid; signalCenter.showMessage(qsTr("Success")) }
        var f = function(err){ loading = false; signalCenter.showMessage(err); }
        loading = true;
        Script.setBookmark(opt, s, f);
    }
    function rmStore(){
        var opt = { add: false, tid: threadId }
        var s = function(){ loading = false; isCollected = false;
            collectMarkPid = ""; signalCenter.showMessage(qsTr("Success")) }
        var f = function(err){ loading = false; signalCenter.showMessage(err); }
        loading = true;
        Script.setBookmark(opt, s, f);
    }
    function createMenu(index,smItem){
        if (!threadMenu)
            threadMenu = Qt.createComponent("ThreadMenu.qml").createObject(view);
        threadMenu.index = index;
        threadMenu.model = view.model.get(index);
        threadMenu.show(smItem);
    }

    function delPost(index){
        var model = view.model.get(index);
        var execute;
        if (model.floor === "1"){
            // delthread
            execute = function(){
                        var opt = {
                            word: forum.name,
                            fid: forum.id,
                            tid: thread.id
                        }
                        loading = true;
                        var s = function(){
                            loading = false;
                            signalCenter.showMessage(qsTr("Success"));
                            // in ThreadPage
                            internal.removeThreadPage(page);
                        }
                        var f = function(err){
                            loading = false;
                            signalCenter.showMessage(err);
                        }
                        Script.delthread(opt, s, f);
                    }
            signalCenter.createQueryDialog(qsTr("Warning"),
                                           qsTr("Delete this thread?"),
                                           qsTr("OK"),
                                           qsTr("Cancel"),
                                           execute);
        } else {
            // delpost
            execute = function(){
                        var opt = {
                            floor: false,
                            vip: user.is_manager === "0",
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

    title: thread ? thread.title : qsTr("New tab");

    ListView {
        id: view;
        anchors.fill: parent;
        boundsBehavior:Flickable.StopAtBounds
        cacheBuffer: 600;
        pressDelay: 200;
        model: ListModel {}
        delegate: Item {
            id: myListItem
            property bool menuOpen: threadMenu != null && threadMenu.parent === myListItem
            width: view.width
            height: menuOpen ? threadMenu.height + contentItem.height : contentItem.height

            ThreadDelegate {
                id: contentItem
                width: view.width
                onClicked: {
                    floor === "1" ? pressAndHold() : signalCenter.enterFloor(thread.id, model.id, undefined, user.is_manager);

                }
                onPressAndHold:{
                    createMenu(index,myListItem);
                    console.log(threadMenu.parent == myListItem)
                }
            }
        }
        footer: FooterItem {
            visible: view.count > 0;
            enabled: !loading;
            onClicked: getlist("next");
        }
        header: ThreadHeader {
            height: constant.fontMedium*2 + Theme.itemSizeSmall + constant.paddingMedium*2;
            visible: thread != null;
        }
        property int flpy0: 0
        onMovementStarted:{
            flpy0=view.contentY;
            toolbar.hideExbar();
        }
        onContentYChanged:{
            if(contentY-flpy0<0){
                toolbar.visible=true
                toolbar.height=toolbar.iheight;
            }else{
                toolbar.height=0;
            }
        }
    }

    VerticalScrollDecorator {
        flickable: view;
    }
    Item{
        id:toolbar
        clip: true;
        function hideExbar(){
            toolbar.showExbar=false;
            toolbar.height=toolbar.iheight;
            mebubtn.visible=true;
            mebubtn_down.visible=false;
        }

        anchors{
            bottom: page.bottom
        }
        height: 0;
        property int iheight: showExbar ? iconbar.height+exbar.height : iconbar.height;
        property bool showExbar: false
        width: page.width;

        Rectangle{
            id:exbar
            anchors.bottom: iconbar.top;
            color: "#08202c"
            height: (Theme.iconSizeMedium+Theme.paddingMedium*2)*4+4;
            width: page.width;
            Column{
                width: page.width;
                height: parent.height;
                TabButton{//Author only-只看楼主
                    icon.source:"image://theme/icon-m-people"
                    text:qsTr("Author only");
                    onClicked: {
                        currentTab.isReverse = false;
                        currentTab.isLz = !currentTab.isLz;
                        currentTab.getlist();
                        toolbar.hideExbar();
                    }
                }
                Rectangle{
                    width: parent.width;
                    height: 1;
                    color: Theme.rgba(Theme.highlightColor, 0.2)
                }
                TabButton{//Reverse-倒叙查看
                    icon.source: "image://theme/icon-m-mobile-network";
                    text:qsTr("Reverse")
                    onClicked: {
                            currentTab.isLz = false;
                            currentTab.isReverse = !currentTab.isReverse;
                            currentTab.getlist();
                        toolbar.hideExbar();
                    }
                }
                Rectangle{
                    width: parent.width;
                    height: 1;
                    color: Theme.rgba(Theme.highlightColor, 0.2)
                }
                TabButton{//Jump to page-跳转
                    icon.source: "image://theme/icon-m-rotate-right";
                    text:qsTr("Jump to page");
                    onClicked: {
                        internal.jumpToPage();
                        toolbar.hideExbar();
                    }
                }
                Rectangle{
                    width: parent.width;
                    height: 1;
                    color: Theme.rgba(Theme.highlightColor, 0.2)
                }
                TabButton{//Open browser-用浏览器打开本帖
                    icon.source: "image://theme/icon-m-computer"
                    text:qsTr("Open browser");
                    onClicked: {
                        signalCenter.openBrowser("http://tieba.baidu.com/p/"+currentTab.threadId);
                        toolbar.hideExbar();
                    }
                }
                Rectangle{
                    width: parent.width;
                    height: 1;
                    color: Theme.rgba(Theme.highlightColor, 0.2)
                }
            }
        }

        Rectangle{
            id:iconbar
            anchors.bottom: parent.bottom
            color: "#08202c"
            height: Theme.iconSizeMedium+Theme.paddingMedium*2;
            width: page.width;
            Row{
                TabButton{
                    icon.source: "image://theme/icon-m-edit"
                    width: (page.width-Theme.iconSizeMedium-Theme.paddingMedium*2)/2
                    text:qsTr("New post");
                    onClicked: {
                        var prop = { isReply: true, caller: currentTab }
                        pageStack.push(Qt.resolvedUrl("../Post/PostPage.qml"), prop);
                        toolbar.hideExbar();
                    }
                }
                TabButton{
                    icon.source: "image://theme/icon-m-refresh"
                    width: (page.width-Theme.iconSizeMedium-Theme.paddingMedium*2)/2
                    text:qsTr("refresh");
                    onClicked: {
                        currentTab.getlist();
                        toolbar.hideExbar();
                    }
                }
                IconButton{
                    id:mebubtn
                    width: Theme.iconSizeMedium+Theme.paddingMedium*2
                    icon.source: "image://theme/icon-m-menu"
                    onClicked: {
                        toolbar.showExbar=true;
                        toolbar.height=toolbar.iheight;
                        mebubtn.visible=false;
                        mebubtn_down.visible=true;
                    }
                }
                IconButton{
                    id:mebubtn_down
                    width: Theme.iconSizeMedium+Theme.paddingMedium*2
                    icon.source: "image://theme/icon-m-down"
                    onClicked: {
                        toolbar.showExbar=false;
                        toolbar.height=toolbar.iheight;
                        mebubtn.visible=true;
                        mebubtn_down.visible=false;
                    }
                }
            }
        }
        Behavior on height {NumberAnimation{duration: 150}}
        Connections {
            target: pageStack
            onCurrentPageChanged: {
                toolbar.hideExbar();
            }
        }
    }
}
