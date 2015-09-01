import QtQuick 2.0
import Sailfish.Silica 1.0
import "Component"
import "Profile"
import "../js/main.js" as Script

MyPage {
    id: page;

    property string uid;
    onUidChanged: getProfile();

    property variant userData: null;
    property bool isMe: getUid() === tbsettings.currentUid;
    property bool isLike: userData ? userData.has_concerned === "1" : false;

    function getUid(){
        return userData ? userData.id : uid;
    }

    function getProfile(){
        var prop = { uid: getUid() };
        loading = true;
        var s = function(obj){ loading = false; userData = obj; }
        var f = function(err){ loading = false; signalCenter.showMessage(err); }
        Script.getUserProfile(prop, s, f);
    }

    function follow(){
        var prop = { portrait: userData.portrait, isFollow: !isLike };
        var s = function(){ loading = false; isLike = prop.isFollow;
            signalCenter.showMessage(qsTr("Success")); }
        var f = function(err){ loading = false; signalCenter.showMessage(err); }
        loading = true;
        Script.followUser(prop, s, f);
    }

    title: qsTr("Profile");

    /*tools: ToolBarLayout {
        BackButton {}
        ToolIcon {
            platformIconId: "toolbar-refresh";
            onClicked: getProfile();
        }
        ToolIcon {
            platformIconId: "toolbar-new-chat";
            enabled: !isMe && userData != null;
            onClicked: {
                var prop = { chatName: userData.name_show, chatId: getUid() };
                pageStack.push(Qt.resolvedUrl("Message/ChatPage.qml"), prop);
            }
        }
    }*/

    Connections {
        target: signalCenter;
        onProfileChanged: {
            userData = null;
            getProfile();
        }
    }

//    PageHeader {
//        id: viewHeader;
//        title: page.title;
//    }

    Image {
        id: imageBg;
        anchors { left: parent.left; right: parent.right; top: parent.top; }
        height: constant.graphicSizeLarge*2.7 - view.contentY;
        clip: true;
        source: "gfx/pic_banner_pic.png"
        fillMode: Image.PreserveAspectCrop;
    }

    Flickable {
        id: view;
        anchors { fill: parent; topMargin: 0; }
        contentWidth: parent.width;
        contentHeight: contentCol.height;
        Column {
            id: contentCol;
            width: parent.width;
            Item { width: 1; height: constant.thumbnailSize; }
            Item {
                width: parent.width;
                height: constant.graphicSizeLarge*2;

                Rectangle {
                    id: bottomBanner;
                    anchors { fill: parent; topMargin: parent.height*3/5; }
                    color: "#00ffffff";
                }

                Image {
                    id: avatar;
                    anchors {
                        left: parent.left; leftMargin: constant.paddingMedium;
                        verticalCenter: parent.verticalCenter;
                    }
                    width: 100; height: 100;
                    source: "gfx/person_photo_bg.png"
                    Image {
                        anchors { fill: parent; margins: constant.paddingMedium; }
                        source: userData ? "http://himg.baidu.com/sys/portraith/item/"+userData.portraith
                                         : "gfx/person_photo.png";
                    }
                }

                Column {
                    anchors {
                        left: avatar.right; leftMargin: constant.paddingMedium;
                        right: parent.right; rightMargin: constant.paddingMedium;
                        bottom: bottomBanner.top;
                    }
                    Row {
                        spacing: constant.paddingSmall;
                        Text {
                            anchors.verticalCenter: parent.verticalCenter;
                            font.pixelSize: constant.fontXSmall;
                            color: "white";
                            text: userData ? userData.name_show : "";
                        }
                        Image {
                            source: {
                                if (userData){
                                    if (userData.sex === "1"){
                                        return "gfx/icon_man"+constant.invertedString;
                                    } else {
                                        return "gfx/icon_woman"+constant.invertedString;
                                    }
                                } else {
                                    return "";
                                }
                            }
                        }
                    }
                    Text {
                        width: parent.width;
                        elide: Text.ElideRight;
                        wrapMode: Text.Wrap;
                        maximumLineCount: 1;
                        textFormat: Text.PlainText;
                        font: constant.labelFont;
                        color: "white";
                        text: userData ? userData.intro : "";
                    }
                }

                Loader {
                    anchors {
                        left: avatar.right; leftMargin: constant.paddingMedium;
                        verticalCenter: bottomBanner.verticalCenter;
                    }
                    sourceComponent: isMe ? editBtnComp : followBtnComp;
                    Component {
                        id: editBtnComp;
                        MouseArea {
                            property string pressString: pressed ? "s" : "n";
                            width: editRow.width + 20;
                            height: constant.graphicSizeMedium;
                            onClicked: pageStack.push(Qt.resolvedUrl("Profile/ProfileEditPage.qml"),
                                                      {userData: userData});
//                            BorderImage {
//                                anchors.fill: parent;
//                                border { left: 25; right: 25; top: 0; bottom: 0; }
//                                source: "gfx/btn_bg_"+parent.pressString+constant.invertedString;
//                                smooth: true;
//                            }
                            Row {
                                id: editRow;
                                anchors.centerIn: parent;
                                spacing: constant.paddingSmall;
                                Image {
                                    anchors.verticalCenter: parent.verticalCenter;
                                    source: "gfx/btn_icon_edit"+constant.invertedString;
                                }
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter;
                                    font.pixelSize: constant.fontXXSmall;
                                    color: constant.colorLight;
                                    text: qsTr("Edit profile");
                                }
                            }
                        }
                    }
                    Component {
                        id: followBtnComp;
                        MouseArea {
                            property string pressString: pressed ? "s" : "n";
                            property string name: isLike ? "bg" : "like";
                            width: 114;
                            height: 46;
                            enabled: userData != null && !loading;
                            onClicked: follow();
//                            BorderImage {
//                                id: icon;
//                                anchors.fill: parent;
//                                border { left: 25; right: 25; top: 0; bottom: 0; }
//                                source: "gfx/btn_%1_%2%3".arg(parent.name).arg(parent.pressString).arg(constant.invertedString);
//                            }
                            Text {
                                visible: isLike;
                                anchors.centerIn: parent;
                                font.pixelSize: constant.fontXXSmall;
                                color: constant.colorLight;
                                text: qsTr("Unfollow");
                            }
                        }
                    }
                }
            }
            Grid {
                id: grid;
                width: parent.width;
                columns: 3;
                ProfileCell {
                    visible: isMe;
                    iconName: "sc";
                    title: qsTr("Collections");
                    markVisible: getUid() === tbsettings.currentUid && infoCenter.bookmark > 0;
                    onClicked: {
                        var prop = { title: title }
                        pageStack.push(Qt.resolvedUrl("Profile/BookmarkPage.qml"), prop);
                    }
                }
                ProfileCell {
                    iconName: "myba";
                    title: qsTr("Tieba");
                    subTitle: userData ? userData.my_like_num : "";
                    onClicked: {
                        var prop = { title: title, uid: getUid() }
                        pageStack.push(Qt.resolvedUrl("Profile/ProfileForumList.qml"), prop);
                    }
                }
                ProfileCell {
                    iconName: "gz";
                    title: qsTr("Concerns");
                    subTitle: userData ? userData.concern_num : "";
                    onClicked: {
                        var prop = { title: title, type: "follow", uid: getUid() }
                        pageStack.push(Qt.resolvedUrl("Profile/FriendsPage.qml"), prop);
                    }
                }
                ProfileCell {
                    iconName: "fs";
                    title: qsTr("Fans")
                    subTitle: userData ? userData.fans_num : "";
                    onClicked: {
                        if (getUid() === tbsettings.currentUid){
                            infoCenter.clear("fans");
                        }
                        var prop = { title: title, type: "fans", uid: getUid() }
                        pageStack.push(Qt.resolvedUrl("Profile/FriendsPage.qml"), prop);
                    }
                    markVisible: getUid() === tbsettings.currentUid && infoCenter.fans > 0;
                }
                ProfileCell {
                    iconName: "tiezi";
                    title: qsTr("Posts");
                    onClicked: {
                        var prop = { title: title, uid: getUid() };
                        pageStack.push(Qt.resolvedUrl("Profile/ProfilePost.qml"), prop);
                    }
                }
            }
        }
    }
}
