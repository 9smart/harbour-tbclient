import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../../js/main.js" as Script

MyPage {
    id: page;

    property string name;
    onNameChanged: internal.getlist();

    objectName: "ForumPage";

    title: internal.getName()

    /*tools: ToolBarLayout {
        BackButton {}
        ToolIcon {
            platformIconId: "toolbar-refresh";
            onClicked: internal.getlist();
        }
        ToolIcon {
            platformIconId: "toolbar-pages-all"
            onClicked: signalCenter.enterThread();
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu";
            onClicked: internal.openMenu();
        }
    }*/

    QtObject {
        id: internal;

        property variant user: ({});
        property variant forum: ({});
        property variant threadIdList: [];

        property bool isLike: forum.is_like === "1";
        property bool hasSigned: forum.sign_in_info ? forum.sign_in_info.user_info.is_sign_in === "1" : false;
        property string signDays: forum.sign_in_info ? forum.sign_in_info.user_info.cont_sign_num : "0";
        property bool signing: false;

        property int totalPage: 0;
        property int currentPage: 0;
        property bool hasMore: false;
        property bool hasPrev: false;
        property int cursor: 0;
        property int curGoodId: 0;

        property bool isGood: false;
        onIsGoodChanged: getlist();

        property variant menu: null;
        property variant jumper: null;
        property variant goodSelector: null;

        function openMenu(){
//            if (!menu)
//                menu = menuComp.createObject(page);
//            menu.open();
        }

        function selectGood(){
            if (!goodSelector){
                goodSelector = goodSelectorComp.createObject(page);
                forum.good_classify.forEach(function(value){
                                                var prop = {
                                                    "class_id": value.class_id,
                                                    "modelData": value.class_name,
                                                    "name": value.class_name
                                                };
                                                goodSelector.model.append(prop);
                                            });
                goodSelector.selectedIndex = curGoodId;
            }
            goodSelector.clicked(0);
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

        function getName(){
            if (forum && forum.hasOwnProperty("name")){
                return forum.name;
            } else {
                return page.name;
            }
        }
        function getlist(option){
            option = option || "renew";
            var opt = {
                page: internal,
                kw: getName(),
                model: view.model
            }
            if (isGood){
                opt.is_good = 1;
                opt.cid = curGoodId;
            }
            function s(obj){
                loading = false;
            }
            function f(err){
                loading = false;
                signalCenter.showMessage(err);
            }
            loading = true;
            if (option === "renew"){
                opt.renew = true;
                Script.getForumPage(opt, s, f);
            } else if (option === "next"){
                if (cursor < threadIdList.length){
                    opt.thread_ids = threadIdList.slice(cursor, cursor+30);
                    opt.forum_id = forum.id;
                    opt.cursor = cursor;
                    Script.getThreadList(opt, s, f);
                } else {
                    opt.renew = true;
                    opt.pn = currentPage + 1;
                    Script.getForumPage(opt, s, f);
                }
            } else if (option === "prev"){
                opt.renew = true;
                opt.pn = Math.max(1, currentPage-1);
                Script.getForumPage(opt, s, f);
            } else if (option === "jump"){
                opt.renew = true;
                opt.pn = currentPage;
                Script.getForumPage(opt, s, f);
            }
        }

        function sign(){
            var opt = { fid: forum.id, kw: forum.name }
            signing = true;
            function s(obj){
                signing = false;
                var rank = obj.user_info.user_sign_rank;
                signalCenter.showMessage(qsTr("Success! Rank: %1").arg(rank));
                hasSigned = true;
                signDays = obj.user_info.cont_sign_num;
                signalCenter.forumSigned(forum.id);
            }
            function f(err){
                signing = false;
                signalCenter.showMessage(err);
            }
            Script.sign(opt, s, f);
        }

        function like(){
            var opt = { fid: forum.id, kw: forum.name };
            loading = true;
            function s(){
                loading = false;
                signalCenter.showMessage(qsTr("Followed"));
                isLike = true;
            }
            function f(err){
                loading = false;
                signalCenter.showMessage(err);
            }
            Script.likeForum(opt, s, f);
        }
    }


//    Component {
//        id: menuComp;
//        PullDownMenu {
//            id: menu;
//            property bool menuEnabled: internal.forum.hasOwnProperty("name");
//            MenuItem {
//                text: qsTr("Boutique");
//                enabled: menu.menuEnabled;
//                property bool privateSelectionIndicator: enabled && internal.isGood;
//                Rectangle {
//                    anchors.fill: parent;
//                    color: "black";
//                    opacity: parent.privateSelectionIndicator ? 0.3 : 0;
//                }
//                onClicked: {
//                    internal.isGood = !internal.isGood;
//                }
//            }
//            MenuItem {
//                text: qsTr("View photos");
//                enabled: menu.menuEnabled;
//                onClicked: pageStack.replace(Qt.resolvedUrl("ForumPicture.qml"),
//                                             {name: internal.getName()});
//            }
//            MenuItem {
//                text: qsTr("Forum manage");
//                visible: internal.user.is_manager === "1"
//                onClicked: {
//                    var url = "http://tieba.baidu.com/mo/q/bawuindex";
//                    url+="?fn="+internal.forum.name;
//                    url+="&fid="+internal.forum.id;
//                    url+="&cuid="+Qt.md5(utility.imei).toUpperCase()+"|"+utility.imei;
//                    url+="&timestamp="+Date.now();
//                    url+="&_client_version=5.5.2";
//                    signalCenter.openBrowser(url);
//                }
//            }
//            MenuItem {
//                text: qsTr("Jump to page");
//                enabled: menu.menuEnabled;
//                onClicked: internal.jumpToPage();
//            }
//            MenuItem {
//                text: qsTr("Create a thread");
//                enabled: menu.menuEnabled;
//                onClicked: {
//                    var prop = { caller: internal };
//                    pageStack.push(Qt.resolvedUrl("../Post/PostPage.qml"), prop);
//                }
//            }
//        }
//    }

    Component {
        id: goodSelectorComp;
        /*SelectionDialog {
            id: goodSelector;
            titleText: qsTr("Boutique");
            model: ListModel {}
            onAccepted: {
                internal.curGoodId = model.get(selectedIndex).class_id;
                internal.getlist();
            }
        }*/
        ComboBox {
            id: combobox

            property ListModel model: ListModel{}

            width: parent.width
            label: qsTr("Boutique");
            currentIndex: -1

            menu: ContextMenu {
                Repeater {
                    model: combobox.model

                    MenuItem {
                        text: modelData
                    }
                }
            }


        }
    }

    /*PageHeader {
        id: viewHeader;
        title: {
            if (internal.isGood){
                var c = internal.forum.good_classify
                for (var i in c){
                    if (c[i].class_id == internal.curGoodId)
                        return c[i].class_name;
                }
                return qsTr("Boutique");
            } else {
                return page.title;
            }
        }
        //onClicked: view.scrollToTop();
        IconButton {
            anchors {
                right: parent.right; rightMargin: constant.paddingMedium;
                verticalCenter: parent.verticalCenter;
            }
            icon.source: "image://theme/icon-m-common-filter";
            visible: internal.isGood && internal.forum.good_classify.length > 0;
            onClicked: internal.selectGood();
        }
    }*/
    SilicaFlickable{
        id:fic
        anchors.fill: parent;
        //topMargin:100
        Component.onCompleted: {
             console.log(fic.contentY)
            fic.contentY= -100;
            fic.scrollToTop();
            console.log(fic.contentY)
        }
        PullDownMenu {
            id: menu;
            property bool menuEnabled: internal.forum.hasOwnProperty("name");
            MenuItem {
                text: qsTr("Boutique");
                enabled: menu.menuEnabled;
                property bool privateSelectionIndicator: enabled && internal.isGood;
                Rectangle {
                    anchors.fill: parent;
                    color: "black";
                    opacity: parent.privateSelectionIndicator ? 0.3 : 0;
                }
                onClicked: {
                    internal.isGood = !internal.isGood;
                }
            }
            MenuItem {
                text: qsTr("View photos");
                enabled: menu.menuEnabled;
                onClicked: pageStack.replace(Qt.resolvedUrl("ForumPicture.qml"),
                                             {name: internal.getName()});
            }
            MenuItem {
                text: qsTr("Forum manage");
                visible: internal.user.is_manager === "1"
                onClicked: {
                    var url = "http://tieba.baidu.com/mo/q/bawuindex";
                    url+="?fn="+internal.forum.name;
                    url+="&fid="+internal.forum.id;
                    url+="&cuid="+Qt.md5(utility.imei).toUpperCase()+"|"+utility.imei;
                    url+="&timestamp="+Date.now();
                    url+="&_client_version=5.5.2";
                    signalCenter.openBrowser(url);
                }
            }
            MenuItem {
                text: qsTr("Jump to page");
                enabled: menu.menuEnabled;
                onClicked: internal.jumpToPage();
            }
            MenuItem {
                text: qsTr("Create a thread");
                enabled: menu.menuEnabled;
                onClicked: {
                    var prop = { caller: internal };
                    pageStack.push(Qt.resolvedUrl("../Post/PostPage.qml"), prop);
                }
            }
        }
        SilicaListView {
            id: view;
            anchors {
                fill: parent;
                //topMargin: 100
            }
            cacheBuffer: 7200;
            pressDelay: 150;
            model: ListModel {}
            header: ForumHeader {
                /*PullToActivate {
                    myView: view;
                    enabled: !loading;
                    onRefresh: {
                        internal.getlist("prev");
                    }
                }*/
                visible: internal.forum && internal.forum.hasOwnProperty("name");
                onSignButtonClicked: internal.sign();
                onLikeButtonClicked: internal.like();
                height: constant.paddingLarge*3+constant.fontSmall+constant.fontXXSmall+Theme.itemSizeSmall;
            }
            delegate: ForumDelegate {
            }
            footer: FooterItem {
                enabled: !loading;
                visible: internal.hasMore || internal.cursor < internal.threadIdList.length-1;
                onClicked: internal.getlist("next");
            }
        }
        VerticalScrollDecorator {
            flickable: view;
        }
    }

    MainBtnMenu{
        mItemX: 2;
        mItemObjX: [{
                "btnName":"",
                "btnPic":"gfx/btn_refresh.png",
                "btnWidth":Screen.width*0.22,
            },{
                "btnName":"",
                "btnPic":"gfx/btn_edit.png",
                "btnWidth":Screen.width*0.22,
            }
        ];
        onBtnFunX: {
            switch(index){
                case 0://编辑
                    internal.getlist();
                    break;
                case 1://发帖
                    var prop = { caller: internal };
                    pageStack.push(Qt.resolvedUrl("../Post/PostPage.qml"), prop);
                    break;
                default:
                    break;
            }
        }

        mItemY: 4;
        mItemObjY: [{
                "btnName":qsTr("Boutique"),
            },{
                "btnName":qsTr("View photos"),
            },{
                "btnName":qsTr("Jump to page"),
            },{
                "btnName":qsTr("History"),
            },
        ];
        onBtnFunY: {
            switch(index){
                case 0://Boutique-精品
                    internal.isGood = !internal.isGood;
                    break;
                case 1://View photos-相册
                    pageStack.replace(Qt.resolvedUrl("ForumPicture.qml"),{name: internal.getName()});
                    break;
                case 2://Jump to page-跳转
                    internal.jumpToPage();
                    break;
                case 3://History-历史
                    signalCenter.enterThread();;
                    break;
                default:
                    break;
            }
        }
    }
}
