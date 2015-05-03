import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Component"

Dialog {
    id: root;

    property variant caller: null;
    property string vcodeMd5: "";
    property string vcodePicUrl: "";

    property string submit: "";

    property bool __isClosing: false;
    property int __isPage;  //to make sheet happy

    //acceptButtonText: qsTr("Continue");
    //rejectButtonText: qsTr("Cancel");

    onAccepted: {
        webView.evaluateJavaScript("IA.submit()");
    }

    Flickable {
        id: flickable;
        anchors.fill: parent;
        contentWidth: Math.max(webView.width, width);
        contentHeight: Math.max(webView.height, height);
        boundsBehavior: Flickable.StopAtBounds;
        SilicaWebView {
            id: webView;
            /*javaScriptWindowObjects: QtObject {
                    WebView.windowObjectName: "VcodeJsInterface";
                    function jsSetVcodeInputResult(canpost, val, callback){
                        if (canpost){
                            signalCenter.vcodeSent(caller, val, root.vcodeMd5);
                        }
                    }
                    function jsSetLoadVcodeFinished(canpost, callback){
                        acceptButton.enabled = canpost;
                        submit = callback;
                    }
                    function jsChangeVcode(callback){
                        webView.evaluateJavaScript(callback+"()");
                    }
                    function jsGetVcodeImageUrl(){
                        return vcodePicUrl+"&t="+Date.now();
                    }
                }*/
            contentsScale: 1.5;
            preferredWidth: flickable.width / contentsScale;
            preferredHeight: flickable.height / contentsScale;
            onLoadStarted: busyInd.visible = true;
            onLoadFinished: busyInd.visible = false;
            onLoadFailed: busyInd.visible = false;
            function setSource(){
                var urlString = "http://c.tieba.baidu.com/c/f/anti/gridcaptcha";
                urlString += "?version=5.4.2";
                urlString += "&cuid="+Qt.md5(utility.imei)+"|"+utility.imei;
                urlString += "&timestamp="+Date.now();
                url = urlString;
            }
        }
    }
    BusyIndicator {
        id: busyInd;
        anchors.centerIn: parent;
        running: true;
        visible: false;
    }

    onStatusChanged: {
        if (status == DialogStatus.Open){
            webView.setSource();
        } else if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy(250);
        }
    }

    Component.onCompleted: {
        acceptButton.enabled = false;
        open();
    }
}
