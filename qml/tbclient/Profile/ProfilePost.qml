import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../../js/main.js" as Script

MyPage {
    id: page;

    property string uid;
    onUidChanged: internal.getlist();

    /*tools: ToolBarLayout {
        BackButton {}
        ToolIcon {
            platformIconId: "toolbar-refresh";
            onClicked: internal.getlist();
        }
    }*/

    QtObject {
        id: internal;

        property int currentPage: 1;
        property bool hasMore: false;

        function getlist(option){
            option = option||"renew";
            var opt = { page: internal, model: view.model, user_id: uid };
            if (option === "renew"){
                opt.pn = 1;
                opt.renew = true;
            } else if (option === "next"){
                opt.pn = currentPage + 1;
            }
            var s = function(){
                loading = false;
            }
            var f = function(err){
                loading = false;
                if (err === "hide")
                    err = qsTr("His posts are not allowed to view");
                signalCenter.showMessage(err);
            }
            loading = true;
            Script.getMyPost(opt, s, f);
        }
    }

    PageHeader {
        id: viewHeader;
        title: page.title;
        MouseArea{
            anchors.fill: parent
            onClicked: view.scrollToTop();
        }
    }
SilicaFlickable{
    anchors.fill: parent;
    PullDownMenu{
               MenuItem{
                   text: qsTr("Refresh")
                   onClicked: {
                       internal.getlist();
                   }
               }
           }
    SilicaListView {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        cacheBuffer: view.height * 5;
        model: ListModel {}
        delegate: postDelegate;

        footer: FooterItem {
            visible: view.count > 0;
            enabled: internal.hasMore && !loading;
            onClicked: internal.getlist("next");
        }
        section {
            property: "reply_time";
            delegate: sectionDelegate;
        }

        Component {
            id: sectionDelegate;
            Column {
                width: view.width;
                Row {
                    x: constant.paddingLarge;
                    Image {
                        source: "../gfx/icon_time_node"+constant.invertedString;
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter;
                        text: section;
                        font.pixelSize: constant.fontXXSmall;
                        color: constant.colorMid;
                    }
                }
                Rectangle {
                    width: parent.width;
                    height: 1;
                    color: constant.colorMarginLine;
                }
            }
        }

        Component {
            id: postDelegate;
            Item {
                id: myListItem
                property Item contextMenu
                property bool menuOpen: contextMenu != null && contextMenu.parent === myListItem
                width: view.width
                height: menuOpen ? contextMenu.height + root.height : root.height;
                AbstractItem {
                    id: root;
                    property bool fromSearch: false
                    implicitHeight: contentCol.height + (constant.paddingLarge+constant.paddingMedium)*2;
                    onClicked: {
                        if (is_floor){
                            if (fromSearch) signalCenter.enterFloor(thread_id, post_id);
                            else signalCenter.enterFloor(thread_id, undefined, post_id);
                        }
                        else {
                            var prop = { title: title, threadId: thread_id, pid: post_id };
                            signalCenter.enterThread(prop);
                        }
                    }
                    onPressAndHold:{
                        contextMenu.show(myListItem);
                    }
                    Image {
                        id: icon;
                        anchors {
                            left: root.paddingItem.left; top: root.paddingItem.top;
                        }
                        asynchronous: true;
                        source: "../gfx/icon_thread_node"+constant.invertedString;
                    }
                    BorderImage {
                        id: background;
                        anchors {
                            left: icon.right; top: root.paddingItem.top;
                            right: root.paddingItem.right; bottom: root.paddingItem.bottom;
                        }
                        border { left: 20; top: 25; right: 10; bottom: 10; }
                        asynchronous: true;
                        source: "../gfx/time_line"+constant.invertedString;
                    }
                    Column {
                        id: contentCol;
                        anchors {
                            left: background.left; leftMargin: 10 + constant.paddingMedium;
                            right: background.right; rightMargin: 10;
                            top: root.paddingItem.top; topMargin: constant.paddingMedium;
                        }
                        spacing: constant.paddingMedium;
                        Item {
                            width: parent.width;
                            height: childrenRect.height;
                            Text {
                                font.pixelSize: constant.fontXXSmall;
                                color: constant.colorMid;
                                text: isReply ? qsTr("Reply at %1").arg(fname) : qsTr("Post at %1").arg(fname);
                            }
                            Text {
                                anchors.right: parent.right;
                                font.pixelSize: constant.fontXXSmall;
                                color: constant.colorTextSelection;
                                text: reply_time;
                            }
                        }
                        Text {
                            width: parent.width;
                            wrapMode: Text.Wrap;
                            font.pixelSize: constant.fontXSmall;
                            color: constant.colorLight;
                            text: title;
                        }
                    }
                }
                EnterThreadMenu{
                    id:contextMenu
                }
            }
        }
    }
    VerticalScrollDecorator {
        flickable: view;
    }
}
}
