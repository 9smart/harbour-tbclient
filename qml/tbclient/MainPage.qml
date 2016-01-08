import QtQuick 2.0
import Sailfish.Silica 1.0
import "Component"
import "Base"
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
//            MenuItem{
//                text: qsTr("Home")
//                onClicked: {
//                    pageStack.push(Qt.resolvedUrl("Explore/FeedPage.qml"));
//                }
//            }
//            MenuItem{
//                text: qsTr("Profile")
//                onClicked: {
//                    pageStack.push(Qt.resolvedUrl("ProfilePage.qml"), { uid: tbsettings.currentUid })
//                }
//            }
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
//            MenuItem{
//                text: qsTr("More")
//                onClicked: {
//                    pageStack.push(Qt.resolvedUrl("MorePage.qml"));
//                }
//            }
        }

        PageHeader {
            id: viewHeader;
            opacity: 1-splash.opacity
            title: page.title;
        }
        Rectangle{
            anchors.centerIn: view
            opacity: 1-splash.opacity
            width:  view.height;
            height: Screen.width//2
            rotation: 90
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#00ffffff" }
                //GradientStop { position: 0.25; color: "#00ffffff" }
                GradientStop { position: 0.5; color: "#05ffffff" }
                GradientStop { position: 0.5; color: "#05000000" }
                //GradientStop { position: 0.75; color: "#00000000" }
                GradientStop { position: 1.0; color: "#00000000" }
            }
        }
        SilicaGridView {
            id: view;
            opacity: 1-splash.opacity
            anchors {
                top:viewHeader.bottom;
                //bottom: tip2.top;
                leftMargin: 5;
            }
            width:parent.width;
            height:parent.height-viewHeader.height//-tip2.height;
            model: ListModel {}
            pressDelay: 120;
            cacheBuffer: 2000;
            cellWidth: width / 2;
            cellHeight: constant.fontLarge*2;

            header: headerComp;
            delegate: forumDelegate;
            clip: true;

            Component {
                id: headerComp;
                Item{
                    width:Screen.width
                    height: constant.fontMedium*2+Theme.paddingMedium
                    Rectangle {
                        id: root;
                        //width: view.width;
                        height: constant.fontMedium*2//constant.graphicSizeLarge;

                        color: headermo.pressed ? "#11ffffff":"#00ffffff";
                        radius:5;
                        border.width: 1;
                        border.color: "#428883";
                        anchors{
                            left: parent.left; leftMargin: 6;
                            right: parent.right; rightMargin: 6;
                        }
                        Row{
                            anchors.left: parent.left;
                            anchors.leftMargin: Theme.paddingMedium;
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: Theme.paddingMedium
                            Image{
                                anchors.verticalCenter: parent.verticalCenter
                                width: root.height/3*2;
                                height: width;
                                source: "image://theme/icon-m-search";
                            }
                            Text{
                                anchors.verticalCenter: parent.verticalCenter
                                width: Screen.width-root.height*2-Theme.paddingMedium*5-12
                                color: "#88ffffff"
                                font.pixelSize: root.height/3;
                                text:"进吧、搜贴"
                            }
//                            Image {
//                                width: root.height/3*2;
//                                height: width
//                                anchors.verticalCenter: parent.verticalCenter;
//                                source: "gfx/icon_tie.png"
//                            }
//                            Image {
//                                width: root.height/3*2;
//                                height: width
//                                anchors.verticalCenter: parent.verticalCenter;
//                                source: "gfx/icon_ba.png"
//                            }
                        }

                        MouseArea {
                            id:headermo
                            anchors.fill: parent;
                            onClicked: pageStack.push(Qt.resolvedUrl("SearchPage.qml"), undefined, true);
                        }
                        Row{
                            anchors.right: root.right
                            anchors.rightMargin: Theme.paddingMedium
                            //spacing: constant.paddingMedium;
                            IconButton{
                                height: root.height;
                                width: height*1.4;
                                icon.width:root.height/3*2;
                                icon.height:icon.width;
                                icon.source: "image://theme/icon-m-message";
                                onClicked: pageStack.push(Qt.resolvedUrl("Message/ReplyPage.qml"));

                                Label{
                                    id:replaycount
                                    anchors{
                                        top:parent.top
                                        right: parent.right
                                        rightMargin: Theme.paddingSmall
                                    }
                                    text:infoCenter.replyme>99?"99+":infoCenter.replyme
                                    font.pixelSize: constant.fontXSmall;
                                    color: constant.colorMid;
                                    elide: Text.ElideRight;
                                    maximumLineCount: 1;
                                }
                                Rectangle{
                                    anchors.fill: parent
                                    color: parent.pressed ? "#11ffffff" :"#00ffffff"
                                }
                            }
                            IconButton{
                                height: root.height;
                                width: height*1.4;
                                icon.width:root.height/3*2//*0.8;
                                icon.height:icon.width;
                                icon.source: "gfx/icon-m-message.png";
                                onClicked: pageStack.push(Qt.resolvedUrl("Message/AtmePage.qml"));
                                Label{
                                    id:atmecount
                                    anchors{
                                        top:parent.top
                                        right: parent.right
                                        rightMargin: Theme.paddingSmall
                                    }
                                    text:infoCenter.atme>99?"99+":infoCenter.atme
                                    font.pixelSize: constant.fontXSmall;
                                    color: constant.colorMid;
                                    elide: Text.ElideRight;
                                    maximumLineCount: 1;
                                }

                                Rectangle{
                                    anchors.fill: parent
                                    color: parent.pressed ? "#11ffffff" :"#00ffffff"
                                }
                            }
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
            }
            Component {
                id: forumDelegate;
                Item {
                    id: root;
                    width: view.cellWidth;
                    height: constant.fontMedium*2;
                    Rectangle {
                        color: mouseArea.pressed ? "#11ffffff":"#00ffffff";
                        anchors {
                            left: parent.left; leftMargin: 5;
                        }
                        width: view.cellWidth-10;
                        height: constant.fontMedium*2;
                        radius:5;
                        //border.width: 1;
                        //border.color: "#428883";
                        Rectangle{
                            anchors.left: parent.left;
                            anchors.bottom: parent.bottom;
                            transformOrigin :Item.BottomLeft
                            width:1
                            height:  parent.width;
                            rotation: 90
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#00ffffff" }
                                GradientStop { position: 0.25; color: "#00ffffff" }
                                GradientStop { position: 0.5; color: "#22ffffff" }
                                GradientStop { position: 0.75; color: "#00ffffff" }
                                GradientStop { position: 1.0; color: "#00ffffff" }
                            }
                        }
                        Text {
                            anchors {
                                left: parent.left; leftMargin: 16;
                                right: infoIcon.left;
                                verticalCenter: parent.verticalCenter;
                            }
                            text: forum_name//+qsTr("bar");
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
                                visible: false//is_sign;
                                width: root.width/8
                                height: sourceSize.height/sourceSize.width*width
                            }
                            Column{
                                anchors.verticalCenter: parent.verticalCenter;
                                Image {
                                    asynchronous: true;
                                    opacity: 0.8
                                    //anchors.verticalCenter: parent.verticalCenter;
                                    source: internal.getGradeIcon(level_id);
                                    width: 34/540*Screen.width//root.width/7;
                                    height: width/34*20;//sourceSize.height/sourceSize.width*width;
                                }
                                Image {
                                    asynchronous: true;
                                    opacity: 0.8
                                    //anchors.verticalCenter: parent.verticalCenter;
                                    source: "gfx/sign_ok.png";
                                    visible: is_sign;
                                    width: 34/540*Screen.width//root.width/7;
                                    height: width/34*20;//sourceSize.height/sourceSize.width*width;
                                }
                            //sign_ok.png
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
            visible: false
            opacity: 1-splash.opacity
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

//            IconButton{
//                id: icn4;
//                width: parent.height*1.2;
//                height: parent.height;
//                anchors.right: icn3.left;
//                icon.source: "gfx/icon_sign.png";
//                onClicked: pageStack.push(Qt.resolvedUrl("BatchSignPage.qml"));
//            }

        }
        VerticalScrollDecorator {
            flickable: view;
        }
    }
    Rectangle {
        id: splash
        visible: !(opacity==0)
        function close(){
            opacity=0;
        }
        function open(){
            opacity=1;
        }

        anchors.fill: parent;
        color: "#00483D8B"
        Image {
            id:wel1
            anchors.horizontalCenter: parent.horizontalCenter
            width: 540/650*Screen.width
            height:  233/650*Screen.width
            y:parent.height/16*7+implicitHeight/2;
            source: "gfx/tieba_logo.png"
        }
        Image {
            id:wel2
            anchors.horizontalCenter: parent.horizontalCenter
            width: 350/650*Screen.width
            height:  134/650*Screen.width
            y:parent.height/4*3;
            source: "gfx/splash_logo.png"
        }
        Text {
            id:wel3
            anchors.top: wel2.bottom;
            anchors.topMargin: Theme.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.6;
            font.pixelSize: Theme.fontSizeTiny
            text:""
        }
        Behavior on opacity {NumberAnimation{duration: 400}}
    }
    Timer {
        id: timerDisplay
        running: true; repeat: false; triggeredOnStart: false
        interval: 1 * 1000
        onTriggered: {
            splash.close();
        }
    }
    Component.onCompleted: {
        if(allindex === 0 && num === 0){
            splash.visible = true;
            timerDisplay.start();
        }
        num+=1;
    }
    onStatusChanged: {
        if (status === PageStatus.Active){
            if (page.forceRefresh){
                page.forceRefresh = false;
                internal.getLikedForum();
            }
        }
        if (status == PageStatus.Active) {
            if (pageStack._currentContainer.attachedContainer == null) {
                pageStack.pushAttached(Qt.resolvedUrl("MorePage.qml"))
            }
        }
    }
    Row{
        anchors.bottom: parent.bottom
        Rectangle{
            anchors.bottom: parent.bottom
            color: Theme.highlightColor
            width: Screen.width/3;
            height: 2
        }
        Rectangle{
            anchors.bottom: parent.bottom
            color: "black"
            width: Screen.width/3;
            height: 2
        }
        Rectangle{
            anchors.bottom: parent.bottom
            color: "black"
            width: Screen.width/3;
            height: 2
        }
    }
}
