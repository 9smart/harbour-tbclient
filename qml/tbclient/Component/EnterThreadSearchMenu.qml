import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Base"

ContextMenu {
    id: myContextMenu;
    property int index: -1;
    property bool fromSearch: true;
    MenuItem {
        text: qsTr("View this post");
        onClicked: {
            if (is_floor){
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
