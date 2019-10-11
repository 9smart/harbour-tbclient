import QtQuick 2.0
import Sailfish.Silica 1.0
import "Component"
import "Base"

MyPage {
    id: page;

    title: qsTr("User Center");
    function init(){
//        var dict = [[qsTr("Tabs"),"folder-empty","signalCenter.enterThread()"],
//                    [qsTr("Browser"),"browser","signalCenter.openBrowser(\"https://m.baidu.com\")"],
//                    [qsTr("Square"),"gallery","pageStack.push(Qt.resolvedUrl(\"Explore/SquarePage.qml\"))"],
//                    [qsTr("Accounts"),"accounts","pageStack.push(Qt.resolvedUrl(\"AccountPage.qml\"))"],
//                    [qsTr("Settings"),"settings","pageStack.push(Qt.resolvedUrl(\"SettingsPage.qml\"))"],
//                    [qsTr("About"),"user-guide","pageStack.push(Qt.resolvedUrl(\"AboutPage.qml\"))"]];
        var dict = [//内容
                    [qsTr("Home"),"gfx/icon-m-home.png","pageStack.push(Qt.resolvedUrl(\"Explore/FeedPage.qml\"))"],
                    [qsTr("Square"),"gfx/icon-m-square.png","pageStack.push(Qt.resolvedUrl(\"Explore/SquarePage.qml\"))"],
                    [qsTr("Tabs"),"gfx/icon-m-tabs.png","signalCenter.enterThread()"],
                    [qsTr("Browser"),"image://theme/icon-m-region","signalCenter.openBrowser(\"https://m.baidu.com\")"],
                    //帐号
                    [qsTr("Profile"),"gfx/icon-m-profile.png","pageStack.push(Qt.resolvedUrl(\"ProfilePage.qml\"), { uid: tbsettings.currentUid })"],
                    [qsTr("Accounts"),"gfx/icon-m-account.png","pageStack.push(Qt.resolvedUrl(\"AccountPage.qml\"))"],
                    ["","",""],
                    ["","",""],
                    //消息
                    [qsTr("Reply me"),"image://theme/icon-m-message","pageStack.push(Qt.resolvedUrl(\"Message/ReplyPage.qml\"))"],
                    [qsTr("At me"),"gfx/icon-m-at.png","pageStack.push(Qt.resolvedUrl(\"Message/AtmePage.qml\"))"],
                    [qsTr("Collections"),"image://theme/icon-m-favorite","pageStack.push(Qt.resolvedUrl(\"Profile/BookmarkPage.qml\"))"],
                    //["","",""],
                    ["","",""],
                    //工具
                    [qsTr("BatchSign"),"gfx/icon-m-batchsign.png","pageStack.push(Qt.resolvedUrl(\"BatchSignPage.qml\"))"],
                    ["","",""],
                    ["","",""],
                    ["","",""],
                    //系统
                    [qsTr("Settings"),"gfx/icon-m-setting.png","pageStack.push(Qt.resolvedUrl(\"SettingsPage.qml\"))"],
                    [qsTr("About"),"gfx/icon-m-about.png","pageStack.push(Qt.resolvedUrl(\"AboutPage.qml\"))"]];
        dict.forEach(function(value){
                         view.model.append({name:value[0],file:value[1],script:value[2]});
                     });
    }

    PageHeader {
        id: viewHeader;
        title: page.title;
    }

    GridView {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        cellWidth:page.width/4;
        cellHeight:page.width/4;
        model: ListModel {}
        delegate:SettingCell{
                    iconSource: file;
                    title: name
                    onClicked: eval(script)
                }

//            Item {
//            width:page.width/3;
//            height: width
//            Column{
//                Image {
//                    width:Theme.iconSizeLarge
//                    height: width
//                    source: "image://theme/"+file;
//                }
//                Text{
//                    text:name
//                }
//            }
//            MouseArea{
//                anchors.fill: parent;
//                onClicked: eval(script)
//            }


////            title: name;
////            //iconSource: "gfx/icon-l-"+file+".png";
////            iconSource: "image://theme/"+file;

//        }
    }

    VerticalScrollDecorator { flickable: view; }
    Row{
        anchors.bottom: parent.bottom
        Rectangle{
            anchors.bottom: parent.bottom
            color: "black"
            width: Screen.width/3;
            height: 2
        }
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
    }
    onStatusChanged: {
        if (status == PageStatus.Active) {
            if (pageStack._currentContainer.attachedContainer == null) {
                pageStack.pushAttached(Qt.resolvedUrl("Explore/SquarePage.qml"))
            }
        }
    }
    Component.onCompleted: init();
}
