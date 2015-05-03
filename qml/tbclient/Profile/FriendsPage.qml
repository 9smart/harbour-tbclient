import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../../js/main.js" as Script

MyPage {
    id: page;

    property string uid;
    property string type;
    onUidChanged: internal.getlist();

    /*tools: ToolBarLayout {
        BackButton {}
        ToolIcon {
            platformIconId: "toolbar-refresh";
            onClicked: internal.getlist();
        }
    }*/

    QtObject {
        id: internal;

        property int currentPage: 1;
        property bool hasMore: false;
        property int totalCount: 0;

        function getlist(option){
            option = option||"renew";
            var opt = {
                page: internal,
                model: view.model,
                uid: uid,
                type: type
            }
            if (option === "renew"){
                opt.pn = 1;
                opt.renew = true;
            } else {
                opt.pn = currentPage + 1;
            }
            var s = function(){ loading = false; }
            var f = function(err){ loading = false; signalCenter.showMessage(err); }
            loading = true;
            Script.getUserPage(opt, s, f);
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
    SilicaListView {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        model: ListModel {}
        delegate: friendDelegate;

        footer: FooterItem {
            visible: view.count > 0;
            enabled: !loading && internal.hasMore;
            onClicked: internal.getlist("next");
        }

        Component {
            id: friendDelegate
            AbstractItem {
                id: root;
                height: column.height+constant.paddingSmall*2;
                onClicked: signalCenter.linkClicked("at:"+model.id);

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
                Column {
                    id:column
                    anchors {
                        left: avatar.right; leftMargin: constant.paddingMedium;
                        right: chatBtn.left; rightMargin: constant.paddingMedium;
                        verticalCenter: parent.verticalCenter;
                    }
                    spacing: constant.paddingSmall;
                    Text {
                        font.pixelSize: constant.fontXSmall;
                        color: constant.colorLight;
                        text: name_show;
                    }
                    Text {
                        width: parent.width;
                        elide: Text.ElideRight;
                        maximumLineCount: 1;
                        wrapMode: Text.WrapAnywhere;
                        textFormat: Text.PlainText;
                        font.pixelSize: constant.fontXXSmall;
                        color: constant.colorMid;
                        text: intro;
                    }
                }

                Image {
                    id: chatBtn;
                    anchors {
                        right: root.paddingItem.right;
                        verticalCenter: parent.verticalCenter;
                    }
                    source: "image://theme/icon-m-toolbar-new-chat"+(theme.inverted?"-white":"");
                    opacity: chatBtnMa.pressed ? 0.7 : 1;
                    MouseArea {
                        id: chatBtnMa;
                        anchors.fill: parent;
                        onClicked: {
                            var prop = { chatName: name_show, chatId: model.id }
                            pageStack.push(Qt.resolvedUrl("../Message/ChatPage.qml"), prop);
                        }
                    }
                }
            }
        }
    }

    VerticalScrollDecorator { flickable: view; }
}
}
