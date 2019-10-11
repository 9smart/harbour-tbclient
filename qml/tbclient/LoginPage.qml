import QtQuick 2.0
import Sailfish.Silica 1.0
import "Component"
import "Base"
import "../js/main.js" as Script

MyPage {
    id: page;

    property bool forceLogin: false;

    objectName: "LoginPage";
    backNavigation :false;

    title: qsTr("Login");

    /*tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: forceLogin||pageStack.depth <= 1 ? Qt.quit() : pageStack.pop();
        }
        CheckBox {
            id: phoneNumberCheck;
            anchors.centerIn: parent;
            enabled: !loading;
            text: qsTr("Use phone number");
        }
    }*/

    function login(vcode, vcodeMd5){
        unField.text = unField.text.replace(/\s/g, "");
        pwField.text = pwField.text.replace(/\s/g, "");
        var un = unField.text//phoneNumberCheck.checked ? pnField.text : unField.text;
        if (un == "" || pwField.text == "") return;
        loading = true;
        var opt = {
            isphone: phoneNumberCheck.checked,
            un: un,
            passwd: pwField.text
        }
        if (vcode){
            opt.vcode = vcode;
            opt.vcode_md5 = vcodeMd5;
        }
        function s(){
            loading = false;
            signalCenter.showMessage(qsTr("Login success!"));
            pageStack.pop();
        }
        function f(err, obj){
            loading = false;
            signalCenter.showMessage("error:"+err);
            if (obj && obj.anti && obj.anti.need_vcode === "1"){
                signalCenter.needVCode(page, obj.anti.vcode_md5, obj.anti.vcode_pic_url, obj.info.vcode_type === "4");
                return;
            }
            pwField.forceActiveFocus();
        }
        Script.login(opt, s, f);
    }

    Connections {
        target: signalCenter;
        onVcodeSent: {
            if (caller === page){
                login(vcode, vcodeMd5);
            }
        }
    }
    PageHeader{
        id: header

        title: parent.title
    }

    SilicaFlickable {
        id: view;
        anchors { fill: parent; topMargin: header.height}
        contentWidth: parent.width;
        contentHeight: contentCol.height + constant.paddingLarge

        Column {
            id: contentCol;
            anchors {
                left: parent.left; right: parent.right;
                top: parent.top; margins: constant.paddingLarge;
            }
            spacing: constant.paddingLarge;
            Text {
                text: phoneNumberCheck.checked ? qsTr("Phone number") : qsTr("ID or e-mail");
                font.weight: Font.Light;
                font.pixelSize: 22;
                color: Theme.primaryColor;
            }

            TextField {
                id: unField;
                KeyNavigation.tab: pwField
                enabled: !loading;
                width: parent.width;
                placeholderText: qsTr("Tap to input");
                inputMethodHints: phoneNumberCheck.checked ? Qt.ImhDialableCharactersOnly :Qt.ImhNoAutoUppercase;
                EnterKey.enabled: text || inputMethodComposing
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: pwField.focus = true
            }

            /*Flipable {
                id: flipable;
                width: parent.width;
                height: unField.height;
                front: TextField {
                    id: unField;
                    enabled: !loading;
                    width: parent.width;
                    placeholderText: qsTr("Tap to input");
                    inputMethodHints: Qt.ImhNoAutoUppercase;
                }
                back: TextField {
                    id: pnField;
                    enabled: !loading;
                    width: parent.width;
                    placeholderText: qsTr("Tap to input");
                    inputMethodHints: Qt.ImhDialableCharactersOnly;
                }
                transform: Rotation {
                    id: flipRot;
                    origin: Qt.vector3d(flipable.width/2, flipable.height/2, 0);
                    axis: Qt.vector3d(0, 1, 0);
                    angle: 0;
                }
                states: State {
                    name: "back";
                    PropertyChanges {
                        target: flipRot; angle: 180;
                    }
                    when: phoneNumberCheck.checked;
                }
                transitions: Transition {
                    RotationAnimation {
                        direction: RotationAnimation.Clockwise;
                    }
                }
            }*/
            Text {
                text: qsTr("Password");
                font.weight: Font.Light;
                font.pixelSize: 22;
                color: Theme.primaryColor;
            }
            PasswordField {
                id: pwField;
                width: parent.width;
                enabled: !loading;
                placeholderText: qsTr("Tap to input");
                echoMode: TextInput.Password;
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText;
                //platformWesternNumericInputEnforced: true;
                EnterKey.enabled: text
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: parent.focus = true
            }

            Button {
                id: loginBtn;
                enabled: !loading
                         && unField.text!==""
                         && pwField.text != "";
                anchors {
                    left: parent.left; right: parent.right;
                    margins: constant.paddingLarge*3;
                }
                text: qsTr("Login");
                onClicked: login();
            }
            Item { width: 1; height: 1; }

            MyButton {
                text: qsTr("Forget password?")
                font.weight: Font.Light;
                font.pixelSize: 22;
                onClicked: Qt.openUrlExternally("https://passport.baidu.com/?getpass_index");
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter;
                text: qsTr("Don't have a Baidu account?");
                color: Theme.highlightColor;
            }
            MyButton {
                anchors.horizontalCenter: parent.horizontalCenter;
                text: qsTr("Click to register");
                font.weight: Font.Light;
                font.pixelSize: 22;
                onClicked: Qt.openUrlExternally("https://wappass.baidu.com/passport/reg");
            }
            TextSwitch {
                id: phoneNumberCheck;
                enabled: !loading;
                text: qsTr("Use phone number");
            }
        }
    }
}
