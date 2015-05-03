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
    Image {
        anchors{
            bottom: bgcol.top;
            bottomMargin: constant.fontSmall;
            horizontalCenter: parent.horizontalCenter;
        }
        source: "gfx/harbour-tbclient.png"
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
            iconSource: "gfx/icon_message.png";
            onTriggered: {
                app.activate();
                console.log(pageStack[pageStack.depth])
                pageStack.push(Qt.resolvedUrl("Message/MessagePage.qml"));
            }
        }

        CoverAction {
            iconSource: "gfx/btn_refresh.png";
            onTriggered:{
                //imsgAt.text=1;
            }
        }
    }
}


