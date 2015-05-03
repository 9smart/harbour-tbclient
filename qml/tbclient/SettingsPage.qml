import QtQuick 2.0
import Sailfish.Silica 1.0
import "Component"

MyPage {
    id: page;

    title: qsTr("Settings");

    PageHeader {
        id: viewHeader;
        title: page.title;
        //onClicked: view.scrollToTop();
    }

    Connections {
        target: signalCenter;
        onImageSelected: {
            if (caller === page){
                tbsettings.bgImageUrl = urls||tbsettings.bgImageUrl;
            }
        }
    }

    SilicaFlickable {
        id: view;
        anchors { fill: parent; topMargin: viewHeader.height; }
        contentWidth: view.width;
        contentHeight: contentCol.height + constant.paddingLarge*2;
        pressDelay: 120;

        Column {
            id: contentCol;
            anchors { top: parent.top; topMargin: constant.paddingLarge; }
            width: parent.width;
//            SettingsItem {
//                title: qsTr("Night theme");
//                Switch {
//                    anchors {
//                        right: parent.right; rightMargin: 18;
//                        verticalCenter: parent.verticalCenter;
//                    }
//                    checked: !tbsettings.whiteTheme;
//                    Component.onCompleted: {
//                        checkedChanged.connect(function(){tbsettings.whiteTheme = !checked})
//                    }
//                }
//            }
            SettingsItem {
                title: qsTr("Show image");
                Switch {
                    anchors {
                        right: parent.right; rightMargin: 18;
                        verticalCenter: parent.verticalCenter;
                    }
                    checked: tbsettings.showImage;
                    Component.onCompleted: {
                        checkedChanged.connect(function(){tbsettings.showImage = checked})
                    }
                }
            }
            SettingsItem {
                title: qsTr("Show abstract");
                Switch {
                    anchors {
                        right: parent.right; rightMargin: 18;
                        verticalCenter: parent.verticalCenter;
                    }
                    checked: tbsettings.showAbstract;
                    Component.onCompleted: {
                        checkedChanged.connect(function(){tbsettings.showAbstract = checked;})
                    }
                }
            }
            SettingsItem {
                title: qsTr("Monitor network changes");
                Switch {
                    anchors {
                        right: parent.right; rightMargin: 18;
                        verticalCenter: parent.verticalCenter;
                    }
                    checked: tbsettings.monitorNetworkMode;
                    Component.onCompleted: {
                        checkedChanged.connect(function(){tbsettings.monitorNetworkMode = checked})
                    }
                }
            }
            Rectangle {
                anchors { left: parent.left; right: parent.right; margins: constant.paddingXLarge; }
                height: 1;
                color: constant.colorMarginLine;
            }
            Text {
                x: 18;
                height: constant.graphicSizeSmall;
                color: constant.colorLight;
                font.pixelSize: constant.fontXSmall;
                text: qsTr("Font size");
                verticalAlignment: Text.AlignBottom;
            }
            Slider {
                minimumValue: constant.fontXXSmall;
                maximumValue: constant.fontXXLarge;
                value: tbsettings.fontSize;
                anchors { left: parent.left; right: parent.right; margins: constant.paddingXLarge; }
                stepSize: 1;
                //valueIndicatorVisible: true;
                onPressedChanged: {
                    if (!pressed){
                        tbsettings.fontSize = value;
                    }
                }
            }
            Text {
                x: 18;
                height: constant.graphicSizeSmall;
                font.pixelSize: constant.fontXSmall;
                color: constant.colorLight;
                text: qsTr("Max tabs count");
                verticalAlignment: Text.AlignBottom;
            }
            Slider {
                minimumValue: 1;
                maximumValue: 10;
                value: tbsettings.maxTabCount;
                anchors { left: parent.left; right: parent.right; margins: constant.paddingXLarge; }
                stepSize: 1;
                //valueIndicatorVisible: true;
                onPressedChanged: {
                    if (!pressed){
                        tbsettings.maxTabCount = value;
                    }
                }
            }
            Rectangle {
                anchors { left: parent.left; right: parent.right; margins: constant.paddingXLarge; }
                height: 1;
                color: constant.colorMarginLine;
            }
            SettingsItem {
                property variant remindDialog: null;
                title: qsTr("Remind settings");
                subtitle: qsTr("Click to set");
                onClicked: {
                    if (!remindDialog)
                        remindDialog = Qt.createComponent("Dialog/RemindSettingDialog.qml").createObject(page);
                    remindDialog.open();
                }
            }
//            SettingsItem {
//                title: qsTr("Background image(long press to clear)");
//                subtitle: tbsettings.bgImageUrl || qsTr("Click to set")
//                onPressAndHold: tbsettings.bgImageUrl = "";
//                onClicked: {
//                    signalCenter.selectImage(page);
//                }
//            }
            SettingsItem {
                property variant signatureDiag: null;
                title: qsTr("Signature")
                subtitle: tbsettings.signature.replace(/(^\s*)|(\s*$)/g,"").replace(/\s/g," ")||qsTr("Click to set");
                onClicked: {
                    if (!signatureDiag)
                        signatureDiag = Qt.createComponent("Dialog/SignatureDialog.qml").createObject(page);
                    signatureDiag.open();
                }
            }
            SettingsItem {
                title: qsTr("User agent");
                subtitle: clientTypeSelector.value;
                height: clientTypeSelector._menuOpen ? 88*4:88;
                ComboBox {
                    id:clientTypeSelector
                    label: qsTr("                         ");
                    currentIndex:tbsettings.clientType-1
                    menu: ContextMenu {
                        MenuItem { text: "iPhone" }
                        MenuItem { text: "Android" }
                        MenuItem { text: "WindowsPhone" }
                    }
                    onCurrentIndexChanged: tbsettings.clientType = currentIndex + 1;
                }
            }
            Rectangle {
                anchors { left: parent.left; right: parent.right; margins: constant.paddingXLarge; }
                height: 1;
                color: constant.colorMarginLine;
            }
            Item { width: 1; height: constant.paddingLarge; }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter;
                text: qsTr("Clear cache");
                onClicked: {
                    utility.clearCache();
                    utility.clearCookies();
                    signalCenter.clearLocalCache();
                    signalCenter.showMessage(qsTr("Operation completed"));
                }
            }
        }
    }

    VerticalScrollDecorator { flickable: view; }
}
