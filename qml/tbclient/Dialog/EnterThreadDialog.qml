import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"

Component {
    id: contextMenuComponent
    ContextMenu {
        id: myContextMenu;
        property int index: -1;
        property variant model: view.model.get(index);
        MenuItem {
            text: qsTr("View this post");
            onClicked: {
                if (isfloor){
                    if (fromSearch) signalCenter.enterFloor(tid, pid);
                    else signalCenter.enterFloor(tid, undefined, pid);
                }
                else {
                    var prop = { title: title, threadId: tid, pid: pid };
                    signalCenter.enterThread(prop);
                }
            }        }
        MenuItem {
            text: qsTr("View this thread");
            onClicked: {
                var prop = { title: title, threadId: tid };
                signalCenter.enterThread(prop);
            }
        }
        MenuItem {
            text: qsTr("View this forum");
            onClicked: signalCenter.enterForum(fname);
        }
    }
}


//MyPage {
//    id: root;
//    property string title;
//    property bool isfloor;
//    property string pid;
//    property string tid;
//    property string fname;
//    property bool fromSearch: false;

//    //titleText: title;
//    PageHeader{
//        title: "...select"
//    }
//    Column{
//        anchors.centerIn: parent;
//        width: parent.width;
//        height: 200;
//        anchors.leftMargin: constant.paddingLarge;
//        Rectangle {
//            width: parent.width;
//            height: 60;
//            color: "#00000000"
//            Text{
//                color: constant.colorLight;
//                text: qsTr("View this post");
//            }
//            MouseArea{
//                anchors.fill: parent;
//                onClicked: {
//                    if (isfloor){
//                        if (fromSearch) signalCenter.enterFloor(tid, pid);
//                        else signalCenter.enterFloor(tid, undefined, pid);
//                    }
//                    else {
//                        var prop = { title: title, threadId: tid, pid: pid };
//                        signalCenter.enterThread(prop);
//                    }
//                }
//            }
//        }
//        Rectangle {
//            width: parent.width;
//            height: 60;
//            color: "#00000000"
//            Text{
//                color: constant.colorLight;
//                text: qsTr("View this thread");
//            }
//            MouseArea{
//                anchors.fill: parent;
//                onClicked: {
//                    var prop = { title: title, threadId: tid };
//                    signalCenter.enterThread(prop);
//                }
//            }
//        }
//        Rectangle {
//            width: parent.width;
//            height: 60;
//            color: "#00000000"
//            Text{
//                color: constant.colorLight;
//                text: qsTr("View this forum");
//            }
//            MouseArea{
//                anchors.fill: parent;
//                onClicked: signalCenter.enterForum(fname);
//            }
//        }
//    }
//}
