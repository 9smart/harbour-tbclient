import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: root;

    property alias text: textArea.text;
    property bool __isClosing: false;
    property int __isPage;  //to make sheet happy

    //acceptButtonText: qsTr("Copy");
    //rejectButtonText: qsTr("Cancel");

    Flickable {
        id: view;
        anchors {
            fill: parent; margins: constant.paddingLarge;
        }
        contentWidth: width;
        contentHeight: textArea.height;
        boundsBehavior: Flickable.StopAtBounds;
        clip: true;

        TextArea {
            id: textArea;
            property int minHeight: view.height;
            width: parent.width;
            readOnly: true;
            textFormat: TextEdit.PlainText;
            function setHeight(){ textArea.height = Math.max(implicitHeight, minHeight); }
            onMinHeightChanged: setHeight();
            onImplicitHeightChanged: setHeight();
        }
    }

    onStatusChanged: {
        if (status === DialogStatus.Closing){
            __isClosing = true;
        } else if (status === DialogStatus.Closed && __isClosing){
            root.destroy(250);
        } else if (status === DialogStatus.Open){
            textArea.selectAll();
        }
    }

    onAccepted: {
        if (textArea.selectedText === "") textArea.selectAll();
        textArea.copy();
        signalCenter.showMessage(qsTr("Operation completed"))
    }

    Component.onCompleted: open();
}
