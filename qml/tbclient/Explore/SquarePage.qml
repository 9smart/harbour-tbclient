import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"
import "../Base"
import "../../js/main.js" as Script

MyPage {
    id: page;

    property variant squareData: null;

    function getlist(){
        var s = function(obj){ squareData = obj; loading = false; }
        var f = function(err){ signalCenter.showMessage(err); loading = false; }
        loading = true;
        Script.getForumSquare(s, f);
    }

    title: qsTr("Square");
    loadingVisible: loading && squareData == null;

    /*tools: ToolBarLayout {
        BackButton {}
        ToolIcon {
            platformIconId: "toolbar-refresh";
            onClicked: getlist();
        }
        ToolIcon {
            platformIconId: "toolbar-list";
            onClicked: pageStack.push(Qt.resolvedUrl("ForumDirPage.qml"));
        }
    }*/
SilicaFlickable{
    anchors.fill: parent

    PullDownMenu{
        MenuItem{
            text: qsTr("Refresh")
            onClicked: {
                page.getlist();
            }
        }
    }
    PageHeader {
        id: viewHeader;
        title: page.title;
        //onClicked: view.scrollToTop();
    }

    SilicaFlickable {
        id: view;
        clip: true
        visible: squareData != null;
        anchors { fill: parent; topMargin: viewHeader.height; }
        contentWidth: contentCol.width;
        contentHeight: contentCol.height;
        Column {
            id: contentCol;
            width: view.width;
//            PullToActivate {
//                myView: view;
//                onRefresh: getlist();
//            }
            PathView {
                id: banner;
                clip: true
                width: parent.width;
                height: Math.floor(width / 3.3);
                model: squareData ? squareData.banner : [];
                preferredHighlightBegin: 0.5;
                preferredHighlightEnd: 0.5;
                path: Path {
                    startX: -banner.width*banner.count/2 + banner.width/2;
                    startY: banner.height/2;
                    PathLine {
                        x: banner.width*banner.count/2 + banner.width/2;
                        y: banner.height/2;
                    }
                }
                delegate: bannerDelegate;
                Component {
                    id: bannerDelegate;
                    Item {
                        implicitWidth: banner.width;
                        implicitHeight: banner.height;
                        Image {
                            id: previewImg;
                            anchors.fill: parent;
                            smooth: true;
                            source: utility.percentDecode(modelData.pic_url);
                        }
                        Image {
                            anchors.centerIn: parent;
                            source: previewImg.status === Image.Ready
                                    ? "" : "../gfx/image_default"+constant.invertedString;
                        }
                        Rectangle {
                            anchors.fill: parent;
                            color: "black";
                            opacity: mouseArea.pressed ? 0.3 : 0;
                        }
                        MouseArea {
                            id: mouseArea;
                            anchors.fill: parent;
                            onClicked: {
                                var link = modelData.link;
                                if (link.indexOf("pb:") === 0){
                                    var prop = { threadId: link.substring(3) };
                                    signalCenter.enterThread(prop);
                                } else if (link.indexOf("opfeature:") === 0){
                                    signalCenter.openBrowser(link.substring(10));
                                } else {
                                    console.log(JSON.stringify(modelData))
                                }
                            }
                        }
                    }
                }
                Timer {
                    running: Qt.application.active && banner.count > 1 && !banner.moving && !view.moving;
                    interval: 3000;
                    repeat: true;
                    onTriggered: banner.incrementCurrentIndex();
                }
            }

            Grid {
                id: flr;
                width: parent.width;
                columns: 2;
                Repeater {
                    model: squareData ? squareData.forum_list_recommend : [];
                    Item {
                        width: flr.width / 2;
                        height: constant.graphicSizeLarge;
                        Text {
                            anchors {
                                fill: parent; margins: constant.paddingLarge;
                            }
                            verticalAlignment: Text.AlignVCenter;
                            elide: Text.ElideRight;
                            //font: constant.labelFont;
                            font.pixelSize: constant.fontXSmall;
                            color: constant.colorLight;
                            text: modelData.title;
                        }
                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                var link = modelData.link;
                                if (link.indexOf("list:")===0){
                                    var prop = { stType: "topBarList|"+index, listId: link.substring(5), title: modelData.title };
                                    pageStack.push(Qt.resolvedUrl("SquareListPage.qml"), prop);
                                }
                            }
                        }
                        Rectangle {
                            anchors.fill: parent;
                            border { width: 1; color: "#88ffffff"; }
                            color: "transparent";
                        }
                    }
                }
            }
            Rectangle {
                id: fbt;
                width: parent.width;
                height: headingLeftLabel.height + constant.paddingMedium*2;
                //color: theme.inverted ? "#2c3543" : "#e6e8ea"
                color: "#22e6e8ea"
                Text {
                    id: headingLeftLabel;
                    anchors {
                        left: parent.left; leftMargin: constant.paddingMedium;
                        verticalCenter: parent.verticalCenter;
                    }
                    text: squareData ? squareData.forum_browse_title||"" : "";
                    font.pixelSize: constant.fontXXSmall;
                    color: constant.colorMid;
                }
            }
            Repeater {
                id: fbr;
                model: squareData ? squareData.forum_browse : [];
                AbstractItem {
                    onClicked: {
                        if (modelData.is_all === "1"){
                            pageStack.push(Qt.resolvedUrl("ForumDirPage.qml"));
                        } else {
                            var link = modelData.link;
                            if (link.indexOf("list:")===0){
                                var prop = { stType: "squareItem|"+index, listId: link.substring(5), title: modelData.title };
                                pageStack.push(Qt.resolvedUrl("SquareListPage.qml"), prop);
                            }
                        }
                    }
                    Image {
                        id: fbrPic;
                        anchors {
                            left: parent.paddingItem.left;
                            top: parent.paddingItem.top;
                            bottom: parent.paddingItem.bottom;
                        }
                        width: height;
                        source: modelData.pic_url;
                    }
                    Column {
                        anchors {
                            left: fbrPic.right; leftMargin: constant.paddingLarge;
                            right: parent.paddingItem.right;
                            verticalCenter: parent.verticalCenter;
                        }
                        spacing: constant.paddingSmall;
                        Text {
                            font.pixelSize: constant.fontXSmall;
                            color: constant.colorLight;
                            text: modelData.title;
                        }
                        Text {
                            width: parent.width;
                            elide: Text.ElideRight;
                            font.pixelSize: constant.fontXXSmall;
                            color: constant.colorMid;
                            text: modelData.sub_title;
                        }
                    }
                }
            }
            Rectangle {
                id: tlt;
                width: parent.width;
                height: headingLeftLabel2.height + constant.paddingMedium*2;
                color: "#22e6e8ea"//theme.inverted ? "#2c3543" : "#e6e8ea"
                Text {
                    id: headingLeftLabel2;
                    anchors {
                        left: parent.left; leftMargin: constant.paddingMedium;
                        verticalCenter: parent.verticalCenter;
                    }
                    text: qsTr("Thread recommend");
                    font.pixelSize: constant.fontXXSmall;
                    color: constant.colorMid;
                }
            }
            ListView {
                id: tlv;
                width: parent.width;
                height: constant.graphicSizeLarge+constant.graphicSizeSmall;
                highlightFollowsCurrentItem: true;
                highlightMoveDuration: 300;
                highlightRangeMode: ListView.StrictlyEnforceRange;
                preferredHighlightBegin: 0;
                preferredHighlightEnd: tlv.width;
                snapMode: ListView.SnapOneItem;
                orientation: ListView.Horizontal;
                model: squareData ? squareData.thread_list : [];
                delegate: tlvDel;
                Component {
                    id: tlvDel;
                    Column {
                        width: tlv.width;
                        AbstractItem {
                            onClicked: {
                                var prop = { title: modelData.title, threadId: modelData.id }
                                signalCenter.enterThread(prop);
                            }
                            Text {
                                id: title;
                                anchors {
                                    left: parent.paddingItem.left;
                                    right: parent.paddingItem.right;
                                    top: parent.top; topMargin: constant.paddingMedium;
                                }
                                elide: Text.ElideRight;
                                font.pixelSize: constant.fontXSmall;
                                color: constant.colorLight;
                                text: modelData.title;
                            }
                            Text {
                                anchors {
                                    left: parent.paddingItem.left;
                                    right: parent.paddingItem.right;
                                    top: title.bottom; topMargin: constant.paddingSmall;
                                }
                                elide: Text.ElideRight;
                                color: constant.colorMid;
                                font.pixelSize: constant.fontXXSmall;
                                text: Script.BaiduParser.__parseRawText(modelData.abstract);
                            }
                        }
                        Item {
                            width: parent.width;
                            height: constant.graphicSizeSmall;
                            Text {
                                anchors {
                                    left: parent.left; leftMargin: constant.paddingLarge;
                                    verticalCenter: parent.verticalCenter;
                                }
                                font.pixelSize: constant.fontXXSmall;
                                color: constant.colorMid;
                                text: modelData.forum_name;
                            }
                            Row {
                                anchors {
                                    right: parent.right; rightMargin: constant.paddingLarge;
                                    verticalCenter: parent.verticalCenter;
                                }
                                Image {
                                    asynchronous: true;
                                    height:constant.fontXSmall;
                                    width:height*1.2;
                                    source: "../gfx/btn_icon_comment_n"+constant.invertedString;
                                }
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter;
                                    text: modelData.reply_num;
                                    font.pixelSize: constant.fontXXSmall;
                                    color: constant.colorMid;
                                }
                            }
                        }
                    }
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter;
                spacing: constant.paddingLarge;
                Repeater {
                    model: tlv.count;
                    Rectangle {
                        width: constant.paddingMedium;
                        height: width;
                        radius: width / 2;
                        border { width: 1; color: constant.colorMarginLine; }
                        color: index === tlv.currentIndex ? "#1080dd" : "transparent";
                    }
                }
            }
            Item { width: 1; height: constant.paddingMedium; }
        }
    }
}
Row{
    anchors.bottom: parent.bottom
    Rectangle{
        anchors.bottom: parent.bottom
        color: "black"
        width: Screen.width/3;
        height: 2
    }
    Rectangle{
        anchors.bottom: parent.bottom
        color: "black"
        width: Screen.width/3;
        height: 2
    }
    Rectangle{
        anchors.bottom: parent.bottom
        color: Theme.highlightColor
        width: Screen.width/3;
        height: 2
    }
}
    Component.onCompleted: getlist();
}
