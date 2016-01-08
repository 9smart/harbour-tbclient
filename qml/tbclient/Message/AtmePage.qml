import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../Base"
import "../../js/main.js" as Script

//Item {
MyPage{
    id: page;
    //height: tabGroup.height; width: tabGroup.width
    //anchors.fill: parent;
    property int currentPage: 1;
    property bool hasMore: false;
    property bool firstStart: true;
        //title: qsTr("At me");

        Component.onCompleted: {
            takeToForeground();
        }
        function positionAtTop(){
            view.scrollToTop();
        }

        function takeToForeground(){
            view.forceActiveFocus();
            if (infoCenter.atme > 0){
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
            var opt = { page: page, model: view.model };
            if (option === "renew"){
                infoCenter.clear("atme");
                opt.renew = true;
                opt.pn = 1;
            } else {
                opt.pn = currentPage + 1;
            }
            loading = true;
            function s(){ loading = false; }
            function f(err){ signalCenter.showMessage(err); loading = false; }
            Script.getAtme(opt, s, f);
        }

        function loadFromCache(){
            try {
                var obj = JSON.parse(utility.getUserData("atme"));
                page.hasMore = obj.page.has_more === "1";
                page.currentPage = obj.page.current_page;
                Script.BaiduParser.loadAtme({model: view.model, renew: true},obj.at_list);
                return true;
            } catch(e){
                return false;
            }
        }


        SilicaFlickable{
            anchors.fill: parent

            SilicaListView {
                id: view;
                anchors.fill: parent;
                header: PageHeader{
                    title:qsTr("At me");
                }

                PullDownMenu{
                    MenuItem{
                        text: qsTr("Refresh")
                        onClicked: {
                            getlist();
                        }
                    }
                }
                model: ListModel {}
                delegate:
                    delegateComp;
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
                                asynchronous: true;
                                anchors.left: root.paddingItem.left;
                                anchors.top: root.paddingItem.top;
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
                                    font.pixelSize: constant.fontXSmall;
                                    textFormat: Text.PlainText;
                                    color: constant.colorLight;
                                }
                                Text {
                                    width: parent.width;
                                    wrapMode: Text.WrapAnywhere;
                                    text: content;
                                    font: constant.labelFont;
                                    textFormat: Text.PlainText;
                                    color: constant.colorLight;
                                }
                                Text {
                                    text: time;
                                    font.pixelSize: constant.fontXXSmall;
                                    color: constant.colorMid;
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
