import QtQuick 2.0
import Sailfish.Silica 1.0
import QtDocGallery 5.0
import org.nemomobile.thumbnailer 1.0

Dialog {
    id: root;

    property variant caller;
    property int __isPage;
    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy(250);
        }
    }

    DocumentGalleryModel {
        id: galleryModel;
        autoUpdate: true;
        rootType: DocumentGallery.Image;
        properties: ["url", "title", "lastModified", "dateTaken"];
        sortProperties: ["-lastModified","-dateTaken", "+title"];
    }

    SilicaGridView {
        id: galleryView;
        model: galleryModel;
        anchors.fill: parent;
        clip: true;
        cellWidth: Math.floor(app.inPortrait ? width/3 : width/5);
        cellHeight: cellWidth;
        header: DialogHeader {
            cancelText : qsTr("Cancel")
            acceptText: qsTr("Pick Images")
        }
        delegate: MouseArea {
            implicitWidth: GridView.view.cellWidth;
            implicitHeight: GridView.view.cellHeight;

            onClicked: {
                signalCenter.imageSelected(caller, url.toString().replace("file://", ""));
                root.accept();
            }

            Image {
                anchors.fill: parent;
                sourceSize.width: parent.width;
                asynchronous: true;
                source: model.url;
                fillMode: Image.PreserveAspectCrop;
                clip: true;
                opacity: parent.pressed ? 0.7 : 1;
            }
        }
    }

    Component.onCompleted: open();
}
