import QtQuick 2.0
import Sailfish.Silica 1.0
import "Component"
import "../js/main.js" as Script

MyPage {
    id: page;

    property bool forceRefresh: false;

    loadingVisible: loading && view.count === 0;

    title: qsTr("My tieba");

    /*tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-home";
            onClicked: pageStack.push(Qt.resolvedUrl("Explore/FeedPage.qml"));
        }
        ToolIcon {
            platformIconId: "toolbar-new-message";
            onClicked: pageStack.push(Qt.resolvedUrl("Message/MessagePage.qml"))
            Bubble {
                anchors.verticalCenter: parent.top;
                anchors.horizontalCenter: parent.horizontalCenter;
                text: {
                    var n = 0;
                    if (tbsettings.remindAtme) n += infoCenter.atme;
                    if (tbsettings.remindPletter) n += infoCenter.pletter;
                    if (tbsettings.remindReplyme) n += infoCenter.replyme;
                    return n>0 ? n : "";
                }
                visible: text != "";
            }
        }
        ToolIcon {
            platformIconId: "toolbar-contact";
            onClicked: pageStack.push(Qt.resolvedUrl("ProfilePage.qml"), { uid: tbsettings.currentUid })
            Bubble {
                anchors.verticalCenter: parent.top;
                anchors.horizontalCenter: parent.horizontalCenter;
                text: {
                    var n = 0;
                    if (tbsettings.remindBookmark) n += infoCenter.bookmark;
                    if (tbsettings.remindFans) n += infoCenter.fans;
                    return n>0 ? n : "";
                }
                visible: text != "";
            }
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu";
            onClicked: pageStack.push(Qt.resolvedUrl("MorePage.qml"));
        }
    }*/

    Connections {
        target: signalCenter;
        onUserChanged: {
            Script.register();
            internal.initialize();
        }
        onForumSigned: {
            if (internal.fromNetwork){
                for (var i=0; i<view.model.count; i++){
                    if (fid === view.model.get(i).forum_id){
                        view.model.setProperty(i, "is_sign", true);
                        break;
                    }
                }
            } else {
                page.forceRefresh = true;
            }
        }
    }

    QtObject {
        id: internal;

        property bool fromNetwork: false;

        function initialize(){
            if (!Script.DBHelper.loadLikeForum(view.model)){
                getLikedForum();
            }
        }

        function getLikedForum(){
            loading = true;
            var opt = { model: view.model };
            function s(){
                loading = false;
                fromNetwork = true;
            }
            function f(err){
                loading = false;
                signalCenter.showMessage(err);
            }
            Script.getRecommentForum(opt, s, f);
        }

        function getGradeIcon(lv){
            return "gfx/icon_grade_lv"+lv+".png";
        }
    }

    SilicaFlickable{
        anchors.fill: parent

        PullDownMenu{
            MenuItem{
                text: qsTr("Home")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("Explore/FeedPage.qml"));
                }
            }
            MenuItem{
                text: qsTr("Profile")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("ProfilePage.qml"), { uid: tbsettings.currentUid })
                }
            }
            MenuItem{
                text: qsTr("BatchSign")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("BatchSignPage.qml"));
                }
            }
            MenuItem{
                text: qsTr("ReFresh")
                onClicked: {
                    internal.getLikedForum();
                }
            }
            MenuItem{
                text: qsTr("More")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("MorePage.qml"));
                }
            }
        }

//        PageHeader {
//            id: viewHeader;
//            title: page.title;
//        }
        Item {//顶部标签
            id:tip1
            anchors.top:parent.top;
            width: parent.width;
            height:constant.graphicSizeLarge;
            Image {
                id: img1
                anchors.right:parent.right;
                width:parent.width/2/2/2.5
                height: width
                anchors.verticalCenter: parent.verticalCenter;
                source: "gfx/icon_ba.png"
            }
            Image {
                id: img2
                anchors.right:img1.left;
                width:parent.width/2/2/2.5
                height: width
                anchors.verticalCenter: parent.verticalCenter;
                source: "gfx/icon_tie.png"
            }
        }
        SilicaGridView {
            id: view;
            anchors {
                top:tip1.bottom;
                //bottom: tip2.top;
                leftMargin: 5;
            }
            width:parent.width;
            height:parent.height-tip1.height-tip2.height;
            model: ListModel {}
            pressDelay: 120;
            cacheBuffer: 2000;
            cellWidth: width / 2;
            cellHeight: constant.fontLarge*2;

            //header: headerComp;
            delegate: forumDelegate;
            clip: true;

            Component {
                id: headerComp;
                Item {
                    id: root;
                    width: view.width;
                    height: constant.graphicSizeLarge;
                    /*PullToActivate {
                        myView: view;
                        onRefresh: internal.getLikedForum();
                    }*/
                    SearchField {
                        anchors {
                            left: parent.left; leftMargin: constant.paddingLarge;
                            right: parent.right; rightMargin: constant.paddingMedium;
                            verticalCenter: parent.verticalCenter;
                        }
                        placeholderText: qsTr("Tap to search");
                    }
                    Rectangle {
                        anchors.bottom: parent.bottom;
                        width: parent.width;
                        height: 1;
                        color: constant.colorMarginLine;
                    }
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: pageStack.push(Qt.resolvedUrl("SearchPage.qml"), undefined, true);
                    }
                    /*IconButton {
                    id: searchBtn;
                    anchors {
                        right: parent.right; rightMargin: constant.paddingLarge;
                        verticalCenter: parent.verticalCenter;
                    }
                    //platformStyle: ButtonStyle { buttonWidth: buttonHeight; }
                    icon.source: "image://theme/icon-m-search"//"image://theme/icon-m-toolbar-mediacontrol-play"+(theme.inverted?"-white":"");
                    onClicked: pageStack.push(Qt.resolvedUrl("SearchPage.qml"), undefined, true);
                }*/
                }
            }
            Component {
                id: forumDelegate;
                Item {
                    id: root;
                    width: view.cellWidth;
                    height: constant.fontMedium*2;
                    Rectangle {
                        color: "#00ffffff";
                        anchors {
                            left: parent.left; leftMargin: 5;
                        }
                        width: view.cellWidth-10;
                        height: constant.fontMedium*2;
                        radius:5;
                        border.width: 1;
                        border.color: "#428883";
                        Text {
                            anchors {
                                left: parent.left; leftMargin: 16;
                                right: infoIcon.left;
                                verticalCenter: parent.verticalCenter;
                            }
                            text: forum_name+qsTr("bar");
                            font.pixelSize: constant.fontSmall;
                            color: constant.colorLight;
                            elide: Text.ElideRight;
                            maximumLineCount: 2;
                        }
                        Row {
                            id: infoIcon;
                            spacing: constant.paddingSmall;
                            anchors {
                                right: parent.right;
                                rightMargin: 5;
                                verticalCenter: parent.verticalCenter;
                            }
                            Image {
                                anchors.verticalCenter: parent.verticalCenter;
                                source: "gfx/icon_sign_ok.png";
                                visible: is_sign;
                                width: root.width/8
                                height: sourceSize.height/sourceSize.width*width
                            }
                            Image {
                                asynchronous: true;
                                anchors.verticalCenter: parent.verticalCenter;
                                source: internal.getGradeIcon(level_id);
                                width: root.width/7;
                                height: sourceSize.height/sourceSize.width*width;
                            }
                        }
                        MouseArea {
                            id: mouseArea;
                            anchors.fill: parent;
                            onClicked: {
                                signalCenter.enterForum(forum_name);
                            }
                        }
                    }
                }
            }
        }
        Rectangle {
            id:tip2
            color: "#00000000"
            anchors{
                top:view.bottom;
                left:parent.left;
            }

            width: parent.width;
            height:Theme.iconSizeMedium + 2 * Theme.paddingMedium;
            IconButton{
                id: icn1;
                width: parent.height;
                height: parent.height;
                anchors.right: parent.right;
                anchors.rightMargin: Theme.paddingMedium;
                icon.source: "image://theme/icon-m-search";
                onClicked: pageStack.push(Qt.resolvedUrl("SearchPage.qml"), undefined, true);
            }
            IconButton{
                id: icn2;
                width: parent.height;
                height: parent.height;
                anchors.right: icn1.left;
                anchors.rightMargin: Theme.paddingMedium;
                icon.source: "image://theme/icon-m-message";
                onClicked: pageStack.push(Qt.resolvedUrl("Message/ReplyPage.qml"));
            }
            IconButton{
                id: icn3;
                width: parent.height*1.2;
                height: parent.height;
                anchors.right: icn2.left;
                icon.source: "gfx/icon-m-message.png";
                onClicked: pageStack.push(Qt.resolvedUrl("Message/AtmePage.qml"));
            }
//            IconButton{
//                id: icn4;
//                width: parent.height*1.2;
//                height: parent.height;
//                anchors.right: icn3.left;
//                icon.source: "gfx/icon_sign.png";
//                onClicked: pageStack.push(Qt.resolvedUrl("BatchSignPage.qml"));
//            }
            Label{
                id:replaycount
                anchors{
                    top:icn2.top
                    right:icn2.right
                    rightMargin: Theme.paddingSmall
                }
                //width:icn2.width
                text:infoCenter.replyme>99?"99+":infoCenter.replyme
                font.pixelSize: constant.fontXSmall;
                color: constant.colorMid;
                elide: Text.ElideRight;
                maximumLineCount: 1;

            }
            Label{
                id:atmecount
                anchors{
                    top:icn3.top
                    right:icn3.right
                    rightMargin: Theme.paddingSmall
                }
                //width: icn3.width
                text:infoCenter.atme>99?"99+":infoCenter.atme
                font.pixelSize: constant.fontXSmall;
                color: constant.colorMid;
                elide: Text.ElideRight;
                maximumLineCount: 1;

            }
        }
        VerticalScrollDecorator {
            flickable: view;
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Active){
            if (page.forceRefresh){
                page.forceRefresh = false;
                internal.getLikedForum();
            }
        }
    }
}
