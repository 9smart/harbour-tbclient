import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../../js/main.js" as Script

Item {
    id: pletterpage;
    height: tabGroup.height; width: tabGroup.width
    property int currentPage: 1;
    property bool hasMore: false;
    property bool firstStart: true;

    //anchors.fill: parent;
//    title: qsTr("Private letters");

    Component.onCompleted: {
        takeToForeground();
    }
    function positionAtTop(){
        view.scrollToTop();
    }

    function takeToForeground(){
        view.forceActiveFocus();
        if (infoCenter.pletter > 0){
            firstStart = false;
            getlist();
        } else if (firstStart){
            firstStart = false;
            if (!loadFromCache()){
                getlist();
            }
        }
    }

    function getlist(option){
        option = option||"renew";
        var opt = { page: pletterpage, model: view.model };
        if (option === "renew"){
            infoCenter.clear("pletter");
            opt.renew = true;
            opt.pn = 1;
        } else {
            opt.pn = currentPage + 1;
        }
        loading = true;
        function s(){ loading = false; }
        function f(err){ signalCenter.showMessage(err); loading = false; }
        Script.getComlist(opt, s, f);
    }

    function loadFromCache(){
        try {
            var obj = JSON.parse(utility.getUserData("pletter"));
            pletterpage.hasMore = obj.has_more === "1";
            pletterpage.currentPage = 1;
            Script.BaiduParser.loadComlist({renew: true, model: view.model}, obj.record);
            return true;
        } catch(e){
            return false;
        }
    }



    function delcom(index){
        var execute = function(){
            loading = true;
            var s = function(){ loading = false; view.model.remove(index);
                signalCenter.showMessage(qsTr("Success"))};
            var f = function(err){ loading = false;
                signalCenter.showMessage(err)};
            var opt = { com_id: view.model.get(index).user_id }
            Script.deleteChatMsg(opt, s, f);
        }
        signalCenter.createQueryDialog(qsTr("Warning"),
                                       qsTr("Delete this chat?"),
                                       qsTr("OK"),
                                       qsTr("Cancel"),
                                       execute);
    }
    SilicaFlickable{
        anchors.fill: parent
        PullDownMenu{
                    MenuItem{
                        text: qsTr("Refresh")
                        onClicked: {
                            getlist();
                        }
                    }
                }
        SilicaListView {
            id: view;
            anchors.fill: parent;
            model: ListModel {}
            delegate: delegateComp;
            //header:
            footer: FooterItem {
                visible: view.count > 0;
                enabled: hasMore && !loading;
                onClicked: getlist("next");
            }
            Component {
                id: delegateComp;
                AbstractItem {
                    id: root;
                    height: constant.thumbnailSize;
                    onPressAndHold: delcom(index);
                    onClicked: {
                        var prop = { chatName: name_show, chatId: user_id };
                        pageStack.push(Qt.resolvedUrl("ChatPage.qml"), prop);
                    }
                    Image {
                        id: avatar;
                        anchors {
                            left: root.left;
                            top: root.top;
                            bottom: root.bottom;
                            margins: 5;
                        }
                        smooth: true;
                        asynchronous: true;
                        width: height;
                        source: portrait;
                    }
                    Column {
                        anchors {
                            left: avatar.right; leftMargin: constant.paddingMedium;
                            right: root.paddingItem.right; top: root.paddingItem.top;
                        }
                        Text {
                            font.pixelSize: constant.fontXSmall;
                            color: constant.colorLight;
                            text: name_show;
                        }
                        Text {
                            width: parent.width;
                            wrapMode: Text.WrapAnywhere;
                            maximumLineCount: 4;
                            elide: Text.ElideRight;
                            text: model.text;
                            color: constant.colorMid;
                            font: constant.labelFont;
                        }
                    }
                    Text {
                        anchors {
                            right: root.paddingItem.right;
                            top: root.paddingItem.top;
                        }
                        font.pixelSize: constant.fontXXSmall;
                        color: constant.colorMid;
                        text: time;
                    }
                    Loader {
                        anchors { right: parent.right; top: root.paddingItem.top; }
                        sourceComponent: unread_count > 0 ? unreadInfo : undefined;
                        Component {
                            id: unreadInfo;
                            Image {
                                asynchronous: true;
                                source: "../gfx/ico_mbar_news_point.png";
                            }
                        }
                    }
                }
            }
        }
        VerticalScrollDecorator { flickable: view; }
    }

}
