import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../../js/main.js" as Script

MyPage {
    id: page;
    title: qsTr("Home page");
    /*tools: ToolBarLayout {
        BackButton {}
        ToolIcon {
            platformIconId: "toolbar-refresh";
            onClicked: internal.getlist();
        }
        ToolIcon {
            platformIconId: "toolbar-application"
            onClicked: pageStack.push(Qt.resolvedUrl("SquarePage.qml"));
        }
    }*/

    QtObject {
        id: internal;

        property bool hasMore: false;
        property int currentPage: 1;
        property int total: 0;

        function getlist(option){
            option = option||"renew";
            var opt = {
                page: internal,
                model: view.model
            }
            if (option === "renew"){
                opt.pn = 1;
                opt.renew = true;
            } else {
                opt.pn = currentPage + 1;
            }
            loading = true;
            var s = function(){ loading = false; }
            var f = function(err){ loading = false; signalCenter.showMessage(err); }
            Script.getForumFeed(opt, s, f);
        }
    }
SilicaFlickable{
    anchors.fill: parent

    PullDownMenu{
        MenuItem{
            text: qsTr("Refresh")
            onClicked: {
                internal.getlist();
            }
        }
    }
    PageHeader {
        id: viewHeader;
        Image {
            anchors.centerIn: parent;
            sourceSize.height: parent.height - constant.paddingSmall;
            source: "../gfx/logo_teiba_top.png"
        }
    }
    SilicaListView {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        cacheBuffer: height * 5;
        model: ListModel {}
        delegate: FeedDelegate {
        }
//        header: PullToActivate {
//            myView: view;
//            onRefresh: internal.getlist();
//        }
        footer: FooterItem {
            visible: view.count > 0;
            enabled: internal.hasMore && !loading;
            onClicked: internal.getlist("next");
        }
    }

    VerticalScrollDecorator { flickable: view; }
}
    Component.onCompleted: internal.getlist();
}
