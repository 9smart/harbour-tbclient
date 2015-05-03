import QtQuick 2.0
import Sailfish.Silica 1.0
import "Component"
import "Thread"
import "../js/main.js" as Script

MyPage {
    id: page;

    property bool firstStart: true;

    title: qsTr("Search");
    //loading: tabGroup.currentTab.loading;


    ViewHeader {
        id: viewHeader;
        title: page.title;
    }
    Item {
        id: searchItem;
        anchors.top: viewHeader.bottom;
        width: parent.width;
        height: constant.graphicSizeLarge;
        SearchField {
            id: searchInput;
            anchors {
                left: parent.left; leftMargin: constant.paddingLarge;
                right: searchBtn.left; rightMargin: constant.paddingMedium;
                verticalCenter: parent.verticalCenter;
            }
            placeholderText: qsTr("Tap to search");
            //onCleared: pageStack.pop(undefined, true);
            Keys.onPressed: {
                if (event.key == Qt.Key_Select
                        ||event.key == Qt.Key_Enter
                        ||event.key == Qt.Key_Return){
                    event.accepted = true;
                }
            }
            onTextChanged: {
                if (tabGroup.current == 0){
                    if (text != "") suggestView.get();
                    else suggestView.model.clear();
                } else if (tabGroup.current == 1){
                    if (text != "") searchView.get();
                    else searchView.model.clear();
                }
            }
        }
        IconButton {
            id: searchBtn;
            anchors {
                right: parent.right; rightMargin: constant.paddingLarge;
                verticalCenter: parent.verticalCenter;
            }
            width: height;
            icon.source: "gfx/toolbar-send-chat.png";
            onClicked: {
                if (tabGroup.current == 0){
                    if (searchInput.text != "")
                        signalCenter.enterForum(searchInput.text);
                } else if (tabGroup.current == 1){
                    if (searchInput.text != "")
                        searchView.get();
                    else
                        searchView.model.clear();
                }

            }
        }
    }
    Row {
        id: tabRow;
        anchors.top: searchItem.bottom;
        width: parent.width;
        Button {
            text: qsTr("Search tieba");
            width: parent.width/3;
            color: tabGroup.current==0 ? constant.colorLight:constant.colorMid;
            onClicked: {
                tabGroup.current=0;
                if (searchInput.text == ""){
                    suggestView.model.clear();
                } else if (suggestView.searchText != searchInput.text){
                    suggestView.get();
                }
            }
        }
        Button {
            text: qsTr("Search posts");
            //tab: searchView;
            width: parent.width/3;
            color: tabGroup.current==1 ? constant.colorLight:constant.colorMid;
            onClicked: {
                tabGroup.current=1;
                if (searchInput.text == "")
                    searchView.model.clear();
                else if (searchInput.text != searchView.searchText)
                    searchView.get();
            }
        }
        Button {
            text: qsTr("Search web");
            width: parent.width/3;
            color:constant.colorMid;
            onClicked: {
                var url = "http://m.baidu.com/"
                if (searchInput.text.length > 0)
                    url += "s?word="+searchInput.text;
                signalCenter.openBrowser(url);
            }
        }
    }
    TabView {
        id: tabGroup;
        tabTag: false;
        anchors {
            left: parent.left; right: parent.right;
            top: tabRow.bottom; bottom: parent.bottom;
        }
        clip: true;
        ListView {
            id: suggestView;
            anchors.fill: parent;
            property string searchText;
            property bool loading: false;
            property string title: qsTr("Search tieba");
            function get(){
                searchText = searchInput.text;
                var opt = { model: suggestView.model, q: searchText };
                loading = true;
                function s(){ loading = false; }
                function f(err){ loading = false; signalCenter.showMessage(err); }
                Script.forumSuggest(opt, s, f);
            }
            model: ListModel {}
            delegate: ListItem {
                //subItemIndicator: true;
                //platformInverted: tbsettings.whiteTheme;
                Text {
                    anchors.verticalCenter: parent.verticalCenter;
                    verticalAlignment: Text.AlignVCenter;
                    elide: Text.ElideRight;
                    font.pixelSize: constant.fontSmall;
                    color: constant.colorLight;
                    text: modelData;
                }
                onClicked: signalCenter.enterForum(modelData);
            }
        }
        ListView {
            id: searchView;
            anchors.fill: parent;
            property string searchText;
            property bool loading: false;
            property bool hasMore: false;
            property int currentPage: 1;
            property string title: qsTr("Search tieba");
            function get(option){
                if (option != "next")
                    searchText = searchInput.text;
                loading = true;
                var opt = {
                    word: searchText,
                    page: searchView,
                    model: searchView.model
                }
                option = option || "renew";
                if (option === "renew"){
                    opt.renew = true;
                    currentPage = 1;
                    opt.pn = 1;
                } else {
                    opt.pn = currentPage + 1;
                }
                var s = function(){ loading = false; }
                var f = function(err){ loading = false; signalCenter.showMessage(err); }
                Script.searchPost(opt, s, f);
            }
            model: ListModel{}
            delegate: searchDelegate;
            footer: FooterItem {
                visible: searchView.count > 0;
                enabled: !searchView.loading && searchView.hasMore && searchView.searchText != ""
                onClicked: searchView.get("next");
            }
            Component {
                id: searchDelegate;
                Item {
                    id: myListItem
                    property Item contextMenu
                    property bool menuOpen: contextMenu != null && contextMenu.parent === myListItem
                    width: searchView.width
                    height: menuOpen ? contextMenu.height + root.height : root.height;
                    AbstractItem {
                        id: root;
                        property bool fromSearch: true;
                        implicitHeight: contentCol.height + constant.paddingLarge*2;
    //                    onClicked: {
    //                        signalCenter.createEnterThreadDialog(title, is_floor, pid, tid, fname, true);
    //                    }
                        onClicked: {
                            if (is_floor){
                                if (fromSearch) signalCenter.enterFloor(tid, pid);
                                else signalCenter.enterFloor(tid, undefined, pid);
                            }
                            else {
                                var prop = { title: title, threadId: tid, pid: pid };
                                signalCenter.enterThread(prop);
                            }
                        }
                        onPressAndHold:{
                            contextMenu.show(myListItem);
                        }
                        Column {
                            id: contentCol;
                            anchors {
                                left: root.paddingItem.left; right: root.paddingItem.right;
                                top: root.paddingItem.top;
                            }
                            spacing: constant.paddingSmall;
                            Text {
                                width: parent.width;
                                wrapMode: Text.Wrap;
                                text: content;
                                color: constant.colorLight;
                                font.pixelSize: constant.fontXSmall;
                                textFormat: Text.PlainText;
                            }
                            Item {
                                width: parent.width;
                                implicitHeight: label.height+constant.paddingMedium*2;

                                Text {
                                    id: label;
                                    anchors {
                                        left: parent.left; leftMargin: constant.paddingMedium;
                                        top: parent.top; topMargin: constant.paddingMedium;
                                        right: parent.right; rightMargin: constant.paddingMedium;
                                    }
                                    text: title;
                                    font.pixelSize: constant.fontSmall;
                                    color: constant.colorMid;
                                    wrapMode: Text.WrapAnywhere;
                                    elide: Text.ElideRight;
                                    maximumLineCount: 1;
                                    textFormat: Text.PlainText;
                                }
                            }
                            Item {
                                width: parent.width;
                                height: childrenRect.height;
                                Text {
                                    font.pixelSize: constant.fontXXSmall;
                                    color: constant.colorMid;
                                    text: fname + qsTr("Bar");
                                }
                                Text {
                                    anchors.right: parent.right;
                                    font.pixelSize: constant.fontXXSmall;
                                    color: constant.colorMid;
                                    text: time;
                                }
                            }
                        }
                    }
                    EnterThreadSearchMenu{
                        id:contextMenu
                    }
                }
            }
        }
    }

    // For keypad
    onStatusChanged: {
        if (status === PageStatus.Active){
            searchInput.forceActiveFocus();
            if (firstStart){
                firstStart = false;
                //searchInput.openSoftwareInputPanel();
            }
        }
    }
}
