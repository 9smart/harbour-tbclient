import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Base"

Item {
    id: root;

    property alias text: button.text;
    signal clicked;

    width: page.width;
    height: visible ? constant.graphicSizeLarge : 0;

    Button {
        id: button;
        anchors {
            left: parent.left; right: parent.right; margins: constant.paddingLarge;
            verticalCenter: parent.verticalCenter;
        }
        text: qsTr("Load More");
        onClicked: root.clicked();
    }
}
