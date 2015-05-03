import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../Thread" as Thread

MyPage {
    id: page;

    property string defaultTab: "replyme";

    objectName: "MessagePage";


    title: qsTr("MessagePage")
    //tabGroup.content[tabGroup.current].title
    PageHeader{
        id:pageHeader;
        title:page.title;
    }

    /*tools: ToolBarLayout {
        BackButton {}
        ToolIcon {
            platformIconId: "toolbar-refresh";
            onClicked: tabGroup.currentTab.getlist();
        }
        ToolIcon {
            platformIconId: "toolbar-new-chat";
            onClicked: {
                var prop = { title: qsTr("Chat"), type: "chat" }
                pageStack.push(Qt.resolvedUrl("../Profile/SelectFriendPage.qml"), prop);
            }
        }
    }*/

    function switchTab(direction){
        var children = viewHeader.layout.children;
        if (children.length > 0){
            var index = -1;
            for (var i=0, l=children.length;i<l;i++){
                if (children[i].tab === tabGroup.currentTab){
                    index = i;
                    break;
                }
            }
            if (index >=0){
                if (direction === "left")
                    index = index > 0 ? index-1 : children.length-1;
                else
                    index = index < children.length-1 ? index+1 : 0;
                tabGroup.currentTab = children[index].tab;
            }
        }
    }

//    Thread.TabHeader {
//        id: viewHeader;
//        Thread.ThreadButton {
//            tab: replyPage;
//            Image {
//                anchors { top: parent.top; right: parent.right; margins: constant.paddingLarge; }
//                source: infoCenter.replyme > 0 ? "../gfx/ico_mbar_news_point.png" : "";
//            }
//        }
//        Thread.ThreadButton {
//            tab: pletterPage;
//            Image {
//                anchors { top: parent.top; right: parent.right; margins: constant.paddingLarge; }
//                source: infoCenter.pletter > 0 ? "../gfx/ico_mbar_news_point.png" : "";
//            }
//        }
//        Thread.ThreadButton {
//            tab: atmePage;
//            Image {
//                anchors { top: parent.top; right: parent.right; margins: constant.paddingLarge; }
//                source: infoCenter.atme > 0 ? "../gfx/ico_mbar_news_point.png" : "";
//            }
//        }
//    }

    TabView {
        id: tabGroup;
        anchors {
            fill: parent;
            topMargin: pageHeader.height;
        }
//        currentTab: defaultTab == "replyme" ? replyPage : defaultTab == "pletter" ? pletterPage : atmePage;
        Rectangle{
            anchors.fill: parent;
            anchors.margins: constant.paddingMedium;
            color: "#00ffffff";
            property  string title: qsTr("Reply me");
            ReplyPage {
                id: replyPage;
            }
        }
        Rectangle{
            anchors.fill: parent;
            anchors.margins: constant.paddingMedium;
            color: "#00ffffff";
            property  string title: qsTr("Pletter me");
            PletterPage {
                id: pletterPage;
            }
        }
        Rectangle{
            anchors.fill: parent;
            anchors.margins: constant.paddingMedium;
            color: "#00ffffff";
            property  string title: qsTr("At me");
            AtmePage {
                id: atmePage;
            }
        }
    }
}
