import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: root;
    property string titleText: "Warming"
    property string message: "Really delete?"
    property string acceptButtonText: "Delete"
    property string rejectButtonText : "Cancle"
    property bool __isClosing: false;
    Column {
        spacing: 10
        anchors.fill: parent
        DialogHeader {
            acceptText: root.acceptButtonText
            cancelText : root.rejectButtonText
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter;
            text: root.titleText
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter;
            text: root.message
        }
    }
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy(250);
        }
    }
    Component.onCompleted: open();
}
