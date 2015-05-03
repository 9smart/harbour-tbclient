import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: root;

    //acceptButtonText: qsTr("Save");
    //rejectButtonText: qsTr("Cancel");

    onAccepted: tbsettings.signature = textArea.text;

    Flickable {
        id: flickable;
        anchors { fill: parent; margins: constant.paddingLarge; }
        contentWidth: width;
        contentHeight: textArea.height;
        onHeightChanged: textArea.setHeight();
        TextArea {
            id: textArea;
            width: parent.width;
            text: tbsettings.signature;
            function setHeight(){
                height = Math.max(implicitHeight, flickable.height);
            }
            onImplicitHeightChanged: setHeight();
        }
    }

    onStatusChanged: {
        if (status === DialogStatus.Open){
            textArea.forceActiveFocus();
        }
    }
}
