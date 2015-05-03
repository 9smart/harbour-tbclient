import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../../js/main.js" as Script

MyPage {
    id: page;

    title: qsTr("Catalogue");

    /*tools: ToolBarLayout {
        BackButton {}
        ToolIcon {
            platformIconId: "toolbar-refresh";
            onClicked: getlist();
        }
    }*/

    function getlist(){
        var s = function(){ loading = false; }
        var f = function(err){ loading = false; signalCenter.showMessage(err); }
        loading = true;
        Script.getForumDir(view.model, s, f);
    }

    PageHeader {
        id: viewHeader;
        title: page.title;
        //onClicked: view.scrollToTop();
    }

    SilicaListView {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        cacheBuffer: view.height * 3;
        model: ListModel {}
        delegate: dirDelegate;

        Component {
            id: dirDelegate;
            AbstractItem {
                id: root;
                onClicked: {
                    var prop = { menuData: model, title: menu_name }
                    pageStack.push(Qt.resolvedUrl("ForumRankPage.qml"), prop);
                }
                Image {
                    id: logo;
                    anchors {
                        left: root.left;
                        top: root.top;
                        bottom: root.bottom;
                        margins: 5;
                    }
                    width: height;
                    asynchronous: true;
                    source: default_logo_url
                }
                Image {
                    id: subItemIcon;
                    anchors {
                        right: root.paddingItem.right;
                        verticalCenter: parent.verticalCenter;
                    }
                    source: "image://theme/icon-m-common-drilldown-arrow"+(theme.inverted?"-inverse":"");
                }
                Column {
                    anchors {
                        left: logo.right; leftMargin: constant.paddingMedium;
                        right: subItemIcon.left;
                        verticalCenter: parent.verticalCenter;
                    }
                    spacing: constant.paddingSmall;
                    Text {
                        text: menu_name;
                        font: constant.labelFont;
                        color: constant.colorLight;
                    }
                    Text {
                        width: parent.width;
                        elide: Text.ElideRight;
                        text: subtitle;
                        font.pixelSize: constant.fontXXSmall;
                        color: constant.colorMid;
                    }
                }
            }
        }
    }

    VerticalScrollDecorator { flickable: view; }

    Component.onCompleted: getlist();
}
