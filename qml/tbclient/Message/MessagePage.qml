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




    SlideshowView{
        id:tabGroup
        //itemWidth: width
        //itemHeight: height
        width: Screen.width
        height: Screen.height - (pageHeader.height /*+  Theme.paddingLarge*/
                                 + viewIndicator.height + tabHeader.childrenRect.height)
        clip:true
        anchors {
            top:pageHeader.bottom
            left:parent.left
            right: parent.right
//            topMargin: (pageHeader.height +  Theme.paddingLarge
//                        + viewIndicator.height + tabHeader.childrenRect.height)
        }
        model: VisualItemModel {
            ReplyPage {
                id: replyPage;
            }
            PletterPage {
                id: pletterPage;
            }
            AtmePage {
                id: atmePage;
            }
        }
    }

    Rectangle {
        anchors.top: tabGroup.bottom
        color: "#00ffffff"
        opacity: 0.5
        height: Theme.paddingMedium
        width: tabGroup.width
        z: 1
    }
    Rectangle {
        id: viewIndicator
        anchors.top: tabGroup.bottom
        color: Theme.highlightColor
        height: Theme.paddingSmall
        width: tabGroup.width / tabGroup.count
        x: tabGroup.currentIndex * width
        z: 2

        Behavior on x {
            NumberAnimation {
                duration: 200
            }
        }
    }

    Row {
        id: tabHeader
        anchors.top: viewIndicator.bottom

        Repeater {
            model: [qsTr("Reply me"), qsTr("Pletter me"),qsTr("At me")]
            Rectangle {
                color: "#00ffffff"
                height: Theme.paddingLarge * 2
                width: tabGroup.width / tabGroup.count

                Label {
                    anchors.centerIn: parent
                    text: modelData
                    color: Theme.highlightColor
                    font {
                        bold: true
                        pixelSize: Theme.fontSizeExtraSmall
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var selectedIndex = parent.x/(tabGroup.width / tabGroup.count) /* === 0 ? 0 :(parent.x === 180?1:360)*/
                        console.log("selected index: ", selectedIndex)
                        console.log("mainView.currentIndex: ", tabGroup.currentIndex)
                        if (selectedIndex !== tabGroup.currentIndex) {
                            if (tabGroup.count>2){
                                tabGroup.currentIndex = selectedIndex
                            }
                            else if (tabGroup.currentIndex<selectedIndex){
                                tabGroup.incrementCurrentIndex()
                            }
                            else{
                                tabGroup.decrementCurrentIndex()
                            }
                        }
                    }
                }
            }
        }
    }

//    TabView {
//        id: tabGroup;
//        anchors {
//            fill: parent;
//            topMargin: pageHeader.height;
//        }
////        currentTab: defaultTab == "replyme" ? replyPage : defaultTab == "pletter" ? pletterPage : atmePage;
//        Rectangle{
//            anchors.fill: parent;
//            anchors.margins: constant.paddingMedium;
//            color: "#00ffffff";
//            property  string title: qsTr("Reply me");
//            ReplyPage {
//                id: replyPage;
//            }
//        }
//        Rectangle{
//            anchors.fill: parent;
//            anchors.margins: constant.paddingMedium;
//            color: "#00ffffff";
//            property  string title: qsTr("Pletter me");
//            PletterPage {
//                id: pletterPage;
//            }
//        }
//        Rectangle{
//            anchors.fill: parent;
//            anchors.margins: constant.paddingMedium;
//            color: "#00ffffff";
//            property  string title: qsTr("At me");
//            AtmePage {
//                id: atmePage;
//            }
//        }
//    }
}
