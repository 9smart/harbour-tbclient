import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../Base"
import "../../js/main.js" as Script

MyPage {
    id: page;

    property variant caller;
    property string type;

    title: qsTr("Select friend");

    QtObject {
        id: internal;
        property int currentPage: 1;
        property bool hasMore: false;
        property int totalCount: 0;

        property variant filterList: [];

        function getlist(){
            var opt = {
                page: internal,
                model: listModel,
                uid: tbsettings.currentUid,
                type: "follow",
                rn: 1000
            }
            var s = function(){ loading = false; filter(); }
            var f = function(err){ loading = false; signalCenter.showMessage(err); }
            loading = true;
            Script.getUserPage(opt, s, f);
        }
        function getSug(text){
            var opt = { q: text }
            var s = function(list){ loading = false; filterList = list||[]; filter(); }
            var f = function(err){ loading = false; signalCenter.showMessage(err); }
            loading = true;
            Script.getFollowSug(opt, s, f);
        }
        function filter(){
            view.model.clear();
            var list = [];
            filterList.forEach(function(value){list.push(value)});
            if (list.length === 0){
                for (var i=0; i<listModel.count; i++){
                    view.model.append(listModel.get(i));
                }
            } else {
                for (var i=0; i<listModel.count && list.length>0; i++){
                    var name = listModel.get(i).name_show;
                    for (var j=0; j<list.length; j++){
                        if (name === list[j]){
                            view.model.append(listModel.get(i));
                            list.splice(j, 1);
                            break;
                        }
                    }
                }
            }
        }
        function itemClicked(model){
            var prop;
            if (type === "chat"){
                prop = { chatName: model.name_show, chatId: model.id };
                pageStack.push(Qt.resolvedUrl("../Message/ChatPage.qml"), prop);
            } else if (type === "at"){
                signalCenter.friendSelected(caller, model.name_show);
                pageStack.pop();
            }
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
    PageHeader {
        id: viewHeader;
        title: page.title;
        MouseArea{
            anchors.fill: parent
            onClicked: view.scrollToTop();
        }
    }

    ListModel { id: listModel; }

    Item {
        id: searchInput;
        anchors { left: parent.left; right: parent.right; top: viewHeader.bottom; }
        height: constant.graphicSizeLarge;
        SearchField {
            anchors {
                left: parent.left; right: parent.right;
                margins: constant.paddingLarge; verticalCenter: parent.verticalCenter;
            }
            placeholderText: qsTr("Tap to search");
            onTextChanged: {
                if (text !== ""){
                    internal.getSug(text);
                } else {
                    internal.filterList = [];
                    internal.filter();
                }
            }
//            onTypeStopped: {
//                if (text !== ""){
//                    internal.getSug(text);
//                } else {
//                    internal.filterList = [];
//                    internal.filter();
//                }
//            }
        }
        Rectangle {
            anchors.bottom: parent.bottom;
            width: parent.width;
            height: 1;
            color: constant.colorMarginLine;
        }
    }
    SilicaListView {
        id: view;
        anchors {
            left: parent.left; right: parent.right;
            top: searchInput.bottom; bottom: parent.bottom;
        }
        clip: true;
        model: ListModel {}

        delegate: deleComp;
        Component {
            id: deleComp;
            AbstractItem {
                id: root;
                onClicked: internal.itemClicked(model);
                Image {
                    id: avatar;
                    anchors {
                        left: root.left;
                        top: root.top;
                        bottom: root.bottom;
                        margins: 5;
                    }
                    width: height;
                    source: portrait;
                }
                Text {
                    anchors {
                        left: avatar.right; leftMargin: constant.paddingMedium;
                        right: root.paddingItem.right;
                        verticalCenter: parent.verticalCenter;
                    }
                    font.pixelSize: constant.fontXSmall;
                    color: constant.colorLight;
                    text: name_show;
                }
            }
        }
    }

    VerticalScrollDecorator { flickable: view; }
}
    Component.onCompleted: internal.getlist();
}
