import QtQuick 2.0
import Sailfish.Silica 1.0
import com.yeatse.tbclient 1.0
import "../Base"
import "../../js/Utils.js" as Utils
Item {
    id: root;

    property variant imageList: [];

    width: parent.width; height: parent.height;

    QtObject {
        id: internal;
        property variant menuComp: null;
        function selectImage(){
            if (!menuComp) menuComp = Qt.createComponent("SelectionMethodMenu.qml");
            menuComp.createObject(root, { caller: root });
        }
        function imageSelected(urls){
            if (urls.length > 0){
                var newList = [];
                var urlList = urls.split("\n");
                imageList.forEach(function(value){newList.push(value)});
                urlList = urlList.filter(function(value){return newList.indexOf(value) === -1});
                imageList = newList.concat(urlList).slice(0,10);
            }
        }
        function removeImage(url){
            imageList = imageList.filter(function(value){return value != url});
        }
    }

    Connections {
        target: signalCenter;
        onImageSelected: {
            if (caller === root){
                internal.imageSelected(urls);
            }
        }
    }

    Connections {
        target: utility;
//        onImageCaptured: {
//            internal.imageSelected(filename);
//        }
    }

    Flickable {
        anchors.fill: parent;
        contentWidth: Math.max(parent.width, imageInsertRow.width);
        contentHeight: parent.height;
        Row {
            id: imageInsertRow;
            anchors.centerIn: parent;
            spacing: constant.paddingLarge;
            Repeater {
                model: root.imageList;
                Item {
                    width: 160;
                    height: 160;
                    Image {
                        anchors.fill: parent;
                        fillMode: Image.PreserveAspectCrop;
                        sourceSize.width: parent.width;
                        source: "file://"+modelData;
                        clip: true;
                        asynchronous: true;
                    }
                    IconButton {
                        anchors {
                            verticalCenter: parent.top;
                            horizontalCenter: parent.right;
                        }
                        icon.source: "image://theme/icon-m-clear"
                        onClicked: internal.removeImage(modelData);
                    }
                }
            }
            Item {
                width: 160;
                height: 160;
                visible: imageList.length < 10;
                IconButton {
                    width: height;
                    height:100;
                    anchors.centerIn: parent;
                    icon.width:constant.graphicSizeLarge;
                    icon.height:constant.graphicSizeLarge;
                    icon.source: "../gfx/btn_pb_add_n.png"
                    onClicked: {
                        signalCenter.selectImage(root);
                        //internal.selectImage();
                    }
                }
            }
        }
    }
}
