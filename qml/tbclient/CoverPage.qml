import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    property int replyme: infoCenter.replyme;
    property int pletter: infoCenter.pletter;
    property int atme: infoCenter.atme;
    Image{
        id:coverBg
        anchors.fill: parent;
        source: "image://theme/graphic-cover-message"
    }
    CoverPlaceholder {
        text: ""
        icon.source: "gfx/harbour-tbclient.png"
    }
    Column{
        id:bgcol
        anchors.centerIn: parent;
        Label{
            id:imsgAt
            anchors.horizontalCenter: parent.horizontalCenter;
            text:qsTr("At(s):")+atme;
        }
//        Label{
//            id:imsgPletter
//            anchors.horizontalCenter: parent.horizontalCenter;
//            text:qsTr("Pletter(s):")+pletter
//        }
        Label{
            id:imsgReply
            anchors.horizontalCenter: parent.horizontalCenter;
            text:qsTr("Reply(es):")+replyme
        }
    }

    CoverActionList {
        id: coverAction
        CoverAction {
            iconSource: "image://theme/icon-cover-message"
            onTriggered: {
                app.activate();
                pageStack.push(Qt.resolvedUrl("Message/ReplyPage.qml"));
            }
        }

        CoverAction {
            iconSource: "gfx/icon-cover-message.png"
            onTriggered:{
                app.activate();
                pageStack.push(Qt.resolvedUrl("Message/AtmePage.qml"));
            }
        }
    }
}


