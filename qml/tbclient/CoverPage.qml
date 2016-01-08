import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    id:coverroot
    property int replyme: infoCenter.replyme;
    property int pletter: infoCenter.pletter;
    property int atme: infoCenter.atme;
    CoverPlaceholder {
        text: ""
        icon.source:"/usr/share/icons/hicolor/86x86/apps/harbour-tbclient.png"
    }

    Image {
        anchors.centerIn: parent;
        anchors.verticalCenterOffset: height/2
        width: Math.min(parent.width/16*13,sourceSize.width);
        height: sourceSize.height/sourceSize.width*width;
        fillMode: Image.PreserveAspectCrop
        source: "gfx/splash_logo.png"
    }
    CoverActionList {
        id: coverAction
        CoverAction {
            id:leftca
            iconSource: "image://theme/icon-cover-message"
            onTriggered: {
                app.activate();
                pageStack.push(Qt.resolvedUrl("Message/ReplyPage.qml"));
            }
        }

        CoverAction {
            id:rightca
            iconSource: "gfx/icon-cover-message.png"
            onTriggered:{
                app.activate();
                pageStack.push(Qt.resolvedUrl("Message/AtmePage.qml"));
            }
        }
    }
    Row{
        id:bgcol
        anchors.bottom:parent.bottom;
        Label{
            id:imsgReply
            width: coverroot.width/2
            horizontalAlignment:Text.AlignHCenter;
            font.pixelSize: constant.fontXSmall;
            text:replyme
            visible: replyme>0;
        }
        Label{
            id:imsgAt
            width: coverroot.width/2
            horizontalAlignment:Text.AlignHCenter;
            font.pixelSize: constant.fontXSmall;
            text:atme;
            visible: atme>0;
        }
    }
}


