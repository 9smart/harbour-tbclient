import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../Base"
import "../../js/main.js" as Script

Item {
    id: root;

    property int toolBarHeight: constant.headerHeight;
    property alias text: inputArea.text;
    property alias cursorPosition: inputArea.cursorPosition;
    property alias emoticonEnabled: faceInsertBtn.enabled;

    anchors.bottom: parent.bottom;
    width: page.width;
    height: 100;

    Connections {
        target: signalCenter;
        onEmoticonSelected: {
            if (caller === root){
                var c = inputArea.cursorPosition;
                inputArea.text = inputArea.text.substring(0, c)+name+inputArea.text.substring(c);
                inputArea.cursorPosition = c + name.length;
            }
        }
    }

    Item {
        id: inputBar;
        anchors.top: parent.top;
        width: parent.width;
        height: Math.max(toolBarHeight, inputAreaFlickable.height+constant.paddingMedium);
        opacity: 0;
        Rectangle{
           anchors.fill: parent;
           color: "#88000000"
        }
        IconButton {
            id: inputBarCancelBtn;
            anchors {
                left: parent.left;
                verticalCenter: parent.verticalCenter;
            }
            icon.source: "../gfx/toolbar-keyboard-below.png";
            onClicked: root.state = "";
        }
        IconButton {
            id: faceInsertBtn;
            anchors {
                left: inputBarCancelBtn.right;
                verticalCenter: parent.verticalCenter;
            }
            icon.source: "../gfx/toolbar-emo.png"
            visible: enabled;
            onClicked: signalCenter.createEmoticonDialog(root);
        }
        IconButton {
            id: sendBtn;
            anchors {
                right: parent.right;
                verticalCenter: parent.verticalCenter;
            }
            icon.source: "../gfx/toolbar-send-chat.png"
            enabled: inputArea.text.length > 0 && !inputArea.errorHighlight && !loading;
            onClicked: internal.addPost();
        }
        Flickable {
            id: inputAreaFlickable;
            anchors {
                left: faceInsertBtn.enabled ? faceInsertBtn.right : inputBarCancelBtn.right;
                right: sendBtn.left;
                verticalCenter: parent.verticalCenter;
            }
            height: Math.min(inputArea.height, 240);
            clip: true;
            boundsBehavior: Flickable.StopAtBounds;
            contentWidth: width;
            contentHeight: inputArea.height;
            TextArea {
                id: inputArea;
                width: parent.width;
                errorHighlight: Script.TextSlicer.textLength(text) > 280;
                function setHeight(){ inputArea.height = Math.max(52, implicitHeight); }
                onImplicitHeightChanged: setHeight();
                font.pixelSize: constant.fontXXSmall;
            }
        }
    }

    states: [
        State {
            name: "Input";
            PropertyChanges { target: app; showToolBar: false; }
            PropertyChanges { target: viewHeader; /*visible: app.showStatusBar;*/ }
            PropertyChanges { target: root; height: inputBar.height; }
            PropertyChanges { target: inputBar; opacity: 1; }
        }
    ]

    transitions: [
        Transition {
            to: "Input";
            SequentialAnimation {
                PropertyAnimation { properties: "height,opacity"; }
                ScriptAction {
                    script: {
                        inputArea.forceActiveFocus();
                        //inputArea.platformOpenSoftwareInputPanel();
                    }
                }
            }
        },
        Transition {
            to: "";
            PropertyAnimation { properties: "height,opacity"; }
            ScriptAction {
                script: view.forceActiveFocus();
            }
        }
    ]
}
