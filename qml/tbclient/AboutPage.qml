import QtQuick 2.0
import Sailfish.Silica 1.0
import "Component"
import "Base"

MyPage {
    id: page;

    title: qsTr("About tbclient");

    PageHeader {
        id: viewHeader;
        title: page.title;
    }

    Column {
        anchors {
            horizontalCenter: parent.horizontalCenter;
            top: viewHeader.bottom;
            //topMargin: inPortrait ? Theme.itemSizeLarge : Theme.paddingLarge;
        }
        spacing: Theme.paddingMedium;

        Image {
            anchors.horizontalCenter: parent.horizontalCenter;
            source: "gfx/harbour-tbclient.png";
        }

        Text {
            font.pixelSize: Theme.fontSizeSmall;
            color: Theme.highlightColor;
            anchors.horizontalCenter: parent.horizontalCenter;
            text: qsTr("QML Tieba Client");
        }

        Text {
            color: Theme.primaryColor;
            anchors.horizontalCenter: parent.horizontalCenter;
            text: "Designed for SailFishOS";
            font.pixelSize: Theme.fontSizeLarge
        }

        Text {
            color: Theme.primaryColor;
            anchors.horizontalCenter: parent.horizontalCenter;
            text: "Version "+utility.appVersion;
            font.pixelSize: Theme.fontSizeMedium;
        }
    }

    Column {
        anchors {
            horizontalCenter: parent.horizontalCenter;
            bottom: parent.bottom; bottomMargin: Theme.paddingMedium;
        }
        Text {
            font.pixelSize: constant.fontSmall;
            color: Theme.primaryColor;
            font.weight: Font.Light;
            width: Screen.width*4/5;
            wrapMode: Text.WrapAnywhere;
            anchors.horizontalCenter: parent.horizontalCenter;
            text: "\tSailish版贴吧客户端是由夜切开发的MeeGo版贴吧改造而来,经由";
        }
        Text {
            font.pixelSize: constant.fontXSmall;
            color: Theme.primaryColor;
            font.weight: Font.Light;
            text: "\t星星@853715872,\n\t@蝉曦,\n\t萌萌@梦影决幻,\n\t大鸟@0312birdzhang"
        }
        Text {
            font.pixelSize: constant.fontSmall;
            color: Theme.primaryColor;
            font.weight: Font.Light;
            text: "共同协作完成\n\n\n\n"
        }
    }
    //    Column {
    //        anchors {
    //            horizontalCenter: parent.horizontalCenter;
    //            bottom: parent.bottom; bottomMargin: Theme.paddingMedium;
    //        }
    //        Text {
    //            font.pixelSize: Theme.fontSizeSmall;
    //            color: Theme.primaryColor;
    //            font.weight: Font.Light;
    //            anchors.horizontalCenter: parent.horizontalCenter;
    //            text: "<a href=\"w\">%1</a>".arg(qsTr("Project homepage"));
    //            onLinkActivated: utility.openURLDefault("https://github.com/yeatse/tbclient");
    //        }
    //        Text {
    //            font.pixelSize: Theme.fontSizeSmall;
    //            color: Theme.primaryColor;
    //            font.weight: Font.Light;
    //            anchors.horizontalCenter: parent.horizontalCenter;
    //            text: "Yeatse CC, 2014";
    //        }
    //    }
}
