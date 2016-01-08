import QtQuick 2.0
import "../Base"

Item {
    id: root;

    property alias paddingItem: paddingItem;

    signal clicked;
    signal pressAndHold;

    implicitWidth: page.width;
    implicitHeight: constant.graphicSizeLarge;

    opacity: mouseArea.pressed ? 0.7 : 1;

    Item {
        id: paddingItem;
        anchors {
            left: parent.left; leftMargin: constant.paddingMedium;
            right: parent.right; rightMargin: constant.paddingMedium;
            top: parent.top; topMargin: constant.paddingMedium;
            bottom: parent.bottom; bottomMargin: constant.paddingMedium;
        }
    }

    Rectangle {
        id: bottomLine;
        anchors {
            left: root.left; right: root.right; bottom: parent.bottom;
        }
        height: 1;
        color: constant.colorMarginLine;
    }

    MouseArea {
        id: mouseArea;
        anchors.fill: parent;
        enabled: root.enabled;
        onClicked: {
            if (root.ListView.view)
                root.ListView.view.currentIndex = index;
            root.clicked();
        }
        onPressAndHold: {
            root.pressAndHold();
        }
    }

    NumberAnimation {
        id: onAddAnimation
        target: root
        property: "opacity"
        duration: 250
        from: 0.25; to: 1;
    }

    ListView.onAdd: {
        onAddAnimation.start();
    }
}
