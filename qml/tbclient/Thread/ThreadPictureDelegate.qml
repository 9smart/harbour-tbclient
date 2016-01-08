import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Floor" as Floor
import "../Component" as Comp
import "../../js/main.js" as Script
import "../Base"

Item {
    id: root;

    implicitWidth: ListView.view.width;
    implicitHeight: ListView.view.height;

    Component.onCompleted: coldDown.start();

    property int totalPage: 0;
    property int currentPage: 1;
    property bool loading: false;

    function scrollToTop(){
        view.scrollToTop();
    }

    function getlist(option){
        option = option||"renew";
        var opt = {
            page: root,
            model: repeater.model,
            tid: threadId,
            kw: internal.forum.name,
            pic_id: pic_id
        }
        if (option == "renew"){
            opt.renew = true;
            opt.pn = 1;
        } else {
            opt.pn = currentPage + 1;
        }
        loading = true;
        function s(count){
            loading = false;
            ListView.view.model.setProperty(index, "comment_amount", count);
        }
        function f(err){
            loading = false;
            signalCenter.showMessage(err);
        }
        Script.getPicComment(opt, s, f);
    }

    SilicaFlickable {
        id: view;
        anchors.fill: parent;
        contentWidth: root.width;
        contentHeight: contentCol.height;
        flickableDirection: Flickable.VerticalFlick;
        Column {
            id: contentCol;
            width: parent.width;
            Item {
                width: root.width;
                height: Math.max(constant.thumbnailSize, width / pic_ratio);
                Image {
                    id: preview;
                    anchors.fill: parent;
                    cache: false;
                    asynchronous: true;
                    sourceSize.width: width;
                    fillMode: Image.PreserveAspectFit;
                    source: url;
                }
                BusyIndicator {
                    anchors.centerIn: parent;
                    running: true;
                    visible: preview.status == Image.Loading;
                }
                MouseArea {
                    anchors.fill: parent;
                    onClicked: signalCenter.viewImage(url,preview.sourceSize.height,preview.sourceSize.width)//signalCenter.viewImage(url)
                }
            }
            Rectangle {
                width: parent.width;
                height: constant.graphicSizeLarge;
                color: "#A0463D3B";
                visible: descr != "";
                Text {
                    anchors { fill: parent; margins: constant.paddingLarge; }
                    font: constant.labelFont;
                    color: "white";
                    wrapMode: Text.Wrap;
                    horizontalAlignment: Text.AlignLeft;
                    verticalAlignment: Text.AlignVCenter;
                    maximumLineCount: 2;
                    elide: Text.ElideRight;
                    text: descr;
                }
            }
            Rectangle {
                width: parent.width;
                height: headingLeftLabel.height + constant.paddingMedium*2;
                color: "#A02c3543"//theme.inverted ? "#2c3543" : "#e6e8ea"
                Text {
                    id: headingLeftLabel;
                    anchors {
                        left: parent.left; leftMargin: constant.paddingMedium;
                        verticalCenter: parent.verticalCenter;
                    }
                    text: user_name;
                    font.pixelSize: constant.fontXXSmall;
                    color: constant.colorMid;
                }
                Text {
                    anchors {
                        right: parent.right; rightMargin: constant.paddingMedium;
                        verticalCenter: parent.verticalCenter;
                    }
                    text: qsTr("Comments")+"(%1)".arg(comment_amount);
                    font.pixelSize: constant.fontXXSmall;
                    color: constant.colorMid;
                }
            }
            Repeater {
                id: repeater;
                model: ListModel {}
                Floor.FloorDelegate {}
            }
            Comp.FooterItem {
                visible: repeater.count > 0;
                enabled: currentPage < totalPage && !loading;
                onClicked: getlist("next");
            }
            Comp.AbstractItem {
                visible: repeater.count == 0;
                Text {
                    anchors.centerIn: parent;
                    text: qsTr("No comments");
                    font: constant.labelFont;
                    color: constant.colorMid;
                }
            }
        }
    }

    Timer {
        id: coldDown;
        interval: 500;
        onTriggered: getlist();
    }
}
