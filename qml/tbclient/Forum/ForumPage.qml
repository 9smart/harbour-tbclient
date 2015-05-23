import QtQuick 2.1
import Sailfish.Silica 1.0
import "../Component"
import "../../js/main.js" as Script

MyPage {
    id: page;

    property string name;
    property alias contentItem:view
    property bool withPanelView: true
    onNameChanged: internal.getlist();

    objectName: "ForumPage";
    title: internal.getName()

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

    PageHeader {
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
                return "" // page.title;
            }
        }
//        IconButton {
//            anchors {
//                right: parent.right; rightMargin: constant.paddingMedium;
//                verticalCenter: parent.verticalCenter;
//            }
//            icon.source: "image://theme/icon-m-common-filter";
//            visible: internal.isGood && internal.forum.good_classify.length > 0;
//            onClicked: internal.selectGood();
//        }
    }

    ListView {
        property int flpy0: 0
        id: view;
        anchors {
            fill: parent;
            //topMargin: 100
        }
        cacheBuffer: 7200;
        pressDelay: 150;
        boundsBehavior:Flickable.StopAtBounds

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

        model: ListModel {}
        header: ForumHeader {
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
                TabButton{//Boutique-精品
                    icon.source: internal.isGood ? "image://theme/icon-m-favorite-selected":"image://theme/icon-m-favorite"
                    text:qsTr("Boutique")
                    onClicked: {
                        internal.isGood = !internal.isGood;
                        toolbar.hideExbar();
                    }
                }
                Rectangle{
                    width: parent.width;
                    height: 1;
                    color: Theme.rgba(Theme.highlightColor, 0.2)
                }
                TabButton{//View photos-相册
                    icon.source: "image://theme/icon-m-image";
                    text:qsTr("View photos");
                    onClicked: {
                        pageStack.replace(Qt.resolvedUrl("ForumPicture.qml"),{name: internal.getName()});
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
                TabButton{//History-历史
                    icon.source: "image://theme/icon-m-edit"
                    text:qsTr("History");
                    onClicked: {
                        signalCenter.enterThread();
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
                        var prop = { caller: internal };
                        pageStack.push(Qt.resolvedUrl("../Post/PostPage.qml"), prop);
                        toolbar.hideExbar();
                    }
                }
                TabButton{
                    icon.source: "image://theme/icon-m-refresh"
                    width: (page.width-Theme.iconSizeMedium-Theme.paddingMedium*2)/2
                    text:qsTr("refresh");
                    onClicked: {
                        internal.getlist();
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
