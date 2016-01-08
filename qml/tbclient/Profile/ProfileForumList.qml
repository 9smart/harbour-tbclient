import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../Base"
import "../../js/main.js" as Script

MyPage {
    id: page;

    property string uid;
    onUidChanged: getlist();

    property bool editMode: false;

    function getlist(){
        loading = true;
        var prop = { uid: uid, model: view.model };
        var s = function(){ loading = false; };
        var f = function(err){ loading = false; signalCenter.showMessage(err); }
        Script.getUserLikedForum(prop, s, f);
    }

    function removeForum(index){
        var model = view.model.get(index);
        var opt = { fid: model.id, favo_type: model.favo_type, kw: model.name };
        loading = true;
        var s = function(){
            loading = false;
            view.model.remove(index);
        }
        var f = function(err){
            loading = false;
            signalCenter.showMessage(err);
        }
        Script.unfavforum(opt, s, f);
    }

    /*tools: ToolBarLayout {
        BackButton {}
        ToolIcon {
            platformIconId: "toolbar-refresh";
            onClicked: getlist();
        }
        ToolIcon {
            platformIconId: editMode ? "toolbar-done" : "toolbar-edit";
            enabled: uid === tbsettings.currentUid;
            onClicked: page.editMode = !page.editMode;
        }
    }*/
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
                           getlist();
                       }
                   }
                   MenuItem{
                       visible: uid === tbsettings.currentUid;
                       text: editMode ? qsTr("Edit Done") : qsTr("To Edit");
                       onClicked: {
                           page.editMode = !page.editMode;
                       }
                   }
               }

        SilicaListView {
            id: view;
            anchors { fill: parent; topMargin: viewHeader.height; }
            model: ListModel {}
            delegate: forumDelegate;
            Component {
                id: forumDelegate;
                AbstractItem {
                    id: root;
                    onClicked: signalCenter.enterForum(name);
                    height: column.height+constant.paddingSmall*2;
                    Image {
                        id: logo;
                        anchors {
                            left: root.left;
                            top: root.top;
                            bottom: root.bottom;
                            margins: 5;
                        }
                        asynchronous: true;
                        width: height;
                        source: avatar;
                    }
                    Column {
                        id:column;
                        anchors {
                            left: logo.right;
                            leftMargin: constant.paddingMedium;
                            right: rightLoader.left;
                            rightMargin: constant.paddingMedium;
                            verticalCenter: parent.verticalCenter;
                        }
                        spacing: constant.paddingSmall;
                        Text {
                            width: parent.width;
                            elide: Text.ElideRight;
                            font.pixelSize: constant.fontXSmall;
                            color: constant.colorLight;
                            text: name;
                        }
                        Text {
                            width: parent.width;
                            elide: Text.ElideRight;
                            font.pixelSize: constant.fontXXSmall;
                            color: constant.colorMid;
                            text: slogan;
                        }
                    }
                    Loader {
                        id: rightLoader;
                        anchors {
                            right: root.paddingItem.right;
                            verticalCenter: parent.verticalCenter;
                        }
                        sourceComponent: editMode ? editBtn : levelText;
                        Component {
                            id: levelText;
                            Text {
                                font.pixelSize: constant.fontXSmall;
                                color: constant.colorMid;
                                text: qsTr("Lv.%1").arg(level_id);
                            }
                        }
                        Component {
                            id: editBtn;
                            IconButton {
                                icon.source: "image://theme/icon-m-delete";
                                onClicked: removeForum(index);
                            }
                        }
                    }
                }
            }
        }
    }
    VerticalScrollDecorator { flickable: view; }
}
