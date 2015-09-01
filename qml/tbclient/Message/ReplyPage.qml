import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../../js/main.js" as Script

Item {
    id: replaypage;
    height: tabGroup.height; width: tabGroup.width

    property int currentPage: 1;
    property bool hasMore: false;
    property bool firstStart: true;

    //anchors.fill: parent;
    //title: qsTr("Reply me");
    Component.onCompleted: {
        takeToForeground();
    }

    function positionAtTop(){
        view.scrollToTop();
    }

    function takeToForeground(){
        view.forceActiveFocus();
        if (infoCenter.replyme > 0){
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
        var opt = { page: replaypage, model: view.model };
        if (option === "renew"){
            infoCenter.clear("replyme");
            opt.renew = true;
            opt.pn = 1;
        } else {
            opt.pn = currentPage + 1;
        }
        loading = true;
        function s(){ loading = false; }
        function f(err){ signalCenter.showMessage(err); loading = false; }
        Script.getReplyme(opt, s, f);
    }

    function loadFromCache(){
        try {
            var obj = JSON.parse(utility.getUserData("replyme"));
            replaypage.hasMore = obj.page.has_more === "1";
            replaypage.currentPage = obj.page.current_page;
            Script.BaiduParser.loadReplyme({model: view.model, renew: true}, obj.reply_list);
            return true;
        } catch(e){
            return false;
        }
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
                Item {
                    id: myListItem
                    property Item contextMenu
                    property bool menuOpen: contextMenu != null && contextMenu.parent === myListItem
                    width: view.width
                    height: menuOpen ? contextMenu.height + root.height : root.height;
                    AbstractItem {
                        id: root;
                        property bool fromSearch: false
                        implicitHeight: contentCol.height + constant.paddingLarge*2;
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
                            id: avatar;
                            anchors {
                                left: root.paddingItem.left;
                                top: root.paddingItem.top;
                            }
                            asynchronous: true;
                            width: constant.graphicSizeMedium;
                            height: constant.graphicSizeMedium;
                            source: portrait;
                        }
                        Column {
                            id: contentCol;
                            anchors {
                                left: avatar.right; leftMargin: constant.paddingMedium;
                                right: root.paddingItem.right;
                                top: root.paddingItem.top;
                            }
                            spacing: constant.paddingSmall;
                            Text {
                                text: replyer;
                                color: constant.colorLight;
                                font.pixelSize: constant.fontXSmall;
                            }
                            Text {
                                width: parent.width;
                                text: quoteMe ? qsTr("Post")+":"+quote_content
                                              : qsTr("Thread")+":"+title;
                                wrapMode: Text.Wrap;
                                textFormat: Text.PlainText;
                                font.pixelSize: constant.fontXXSmall;
                                color: constant.colorLight;
                            }
                            Item {
                                width: parent.width;
                                implicitHeight: label.height+constant.paddingMedium*2+5;
                                BorderImage {
                                    asynchronous: true;
                                    anchors.fill: parent;
                                    source: "../gfx/retweet_bg"+constant.invertedString;
                                    border { left: 32; right: 10; top: 15; bottom: 10; }
                                    opacity: 0.2;
                                }
                                Text {
                                    id: label;
                                    anchors {
                                        left: parent.left; leftMargin: constant.paddingMedium;
                                        top: parent.top; topMargin: constant.paddingMedium+5;
                                        right: parent.right; rightMargin: constant.paddingMedium;
                                    }
                                    text: content;
                                    elide: Text.ElideRight;
                                    textFormat: Text.PlainText;
                                    font.pixelSize: constant.fontXXSmall;
                                    color: constant.colorMid;
                                    wrapMode: Text.WrapAnywhere;
                                    maximumLineCount: 4;
                                }
                            }
                            Text {
                                color: constant.colorMid;
                                font.pixelSize: constant.fontXXSmall;
                                text: qsTr("From %1").arg(fname)+"  "+time;
                            }
                        }
                    }
                    EnterThreadMenu{
                        id:contextMenu
                    }
                }
            }
        }
        VerticalScrollDecorator { flickable: view; }
    }

}
