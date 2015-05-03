import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../../js/main.js" as Script

MyPage {
    id: page;

    property string name;
    onNameChanged: internal.getlist();

    //orientationLock: PageOrientation.LockPortrait;

    loadingVisible: loading && listModel1.count == 0 && listModel1.count == 0;

    title: internal.getName();

    /*tools: ToolBarLayout {
        BackButton {}
        ToolIcon {
            platformIconId: "toolbar-refresh";
            onClicked: internal.getlist();
        }
        ToolIcon {
            id: editBtn;
            platformIconId: "toolbar-edit";
            onClicked: {
                var prop = { caller: internal };
                pageStack.push(Qt.resolvedUrl("../Post/PostPage.qml"), prop);
            }
        }
        ToolIcon {
            id: listBtn;
            platformIconId: "toolbar-list";
            onClicked: pageStack.replace(Qt.resolvedUrl("ForumPage.qml"),{name: internal.getName()});
        }
    }*/

    QtObject {
        id: internal;

        property variant forum: ({});
        property variant photolist: [];

        property int batchStart: 1;
        property int batchEnd: pageSize;
        property int pageSize: 300;
        property bool hasMore: false;
        property int cursor: 0;

        function getName(){
            if (forum && forum.hasOwnProperty("name")){
                return forum.name;
            } else {
                return page.name;
            }
        }

        function getlist(option){
            option = option||"renew";
            var opt = {
                kw: getName(),
                model1: listModel1,
                model2: listModel2,
                page: internal
            };
            function s(){ loading = false; view.finished(); }
            function f(err){ loading = false; signalCenter.showMessage(err); }
            loading = true;
            if (option === "renew"){
                opt.bs = 1;
                opt.be = pageSize;
                opt.renew = true;
                Script.getPhotoPage(opt, s, f);
            } else if (option === "next"){
                if (cursor < photolist.length){
                    var list = photolist.slice(cursor, cursor+30);
                    opt.ids = list;
                    Script.getPhotoList(opt, s, f);
                } else if (hasMore){
                    opt.bs = batchEnd + 1;
                    opt.be = batchEnd + pageSize;
                    opt.renew = true;
                    Script.getPhotoPage(opt, s, f);
                }
            } else if (option === "prev"){
                if (batchStart > pageSize){
                    opt.bs = batchStart - pageSize;
                    opt.be = batchStart - 1;
                } else {
                    opt.bs = 1;
                    opt.be = pageSize;
                }
                opt.renew = true;
                Script.getPhotoPage(opt, s, f);
            }
        }
    }

    ViewHeader {
        id: viewHeader;
        title: page.title;
        onClicked: view.scrollToTop();
    }

    SilicaFlickable {
        id: view;

        signal finished;

        anchors { fill: parent; topMargin: viewHeader.height; }
        contentWidth: parent.width;
        contentHeight: contentCol.height;

        Column {
            id: contentCol;
            anchors { left: parent.left; right: parent.right; }
            PullToActivate {
                myView: view;
                enabled: !loading;
                onRefresh: internal.getlist("prev");
            }
            Row {
                anchors { left: parent.left; right: parent.right; }
                Column {
                    width: parent.width / 2;
                    Repeater {
                        model: ListModel { id: listModel1; property int cursor: 0; }
                        ForumPictureDelegate {}
                    }
                }
                Column {
                    width: parent.width / 2;
                    Repeater {
                        model: ListModel { id: listModel2; property int cursor: 0; }
                        ForumPictureDelegate {}
                    }
                }
            }
            FooterItem {
                visible: listModel1.count + listModel2.count > 0;
                enabled: !loading && (internal.hasMore||internal.cursor<internal.photolist.length)
                onClicked: internal.getlist("next");
            }
        }
    }

    VerticalScrollDecorator { flickable: view; }
}
