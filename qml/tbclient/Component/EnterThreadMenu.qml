import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Base"

ContextMenu {
    id: myContextMenu;
    property int index: -1;
    property bool fromSearch: false;
    MenuItem {
        text: qsTr("View this post");
        onClicked: {
            if (is_floor){
                if (fromSearch) signalCenter.enterFloor(thread_id, post_id);
                else signalCenter.enterFloor(thread_id, undefined, post_id);
            }
            else {
                var prop = { title: title, threadId: thread_id, pid: post_id };
                signalCenter.enterThread(prop);
            }
        }        }
    MenuItem {
        text: qsTr("View this thread");
        onClicked: {
            var prop = { title: title, threadId: thread_id };
            signalCenter.enterThread(prop);
        }
    }
    MenuItem {
        text: qsTr("View this forum");
        onClicked: signalCenter.enterForum(fname);
    }
}
