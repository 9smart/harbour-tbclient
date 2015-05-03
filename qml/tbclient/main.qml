import QtQuick 2.0
import Sailfish.Silica 1.0
import com.yeatse.tbclient 1.0
import QtQuick.LocalStorage 2.0
import "Component"
import "../js/main.js" as Script
import "../js/WorkerScript.js" as Worker

ApplicationWindow {
    id: app;

    initialPage: MainPage { id: mainPage; }

    TBSettings { id: tbsettings; }

    Constant { id: constant; }

    SignalCenter { id: signalCenter; }

    InfoCenter { id: infoCenter; }

    AudioWrapper { id: audioWrapper; }

    ImageUploader {
        id: imageUploader;
        property variant caller: null;
        function signForm(params){
            return Script.BaiduRequest.generateSignature(params);
        }
        function jsonParse(data){
            return JSON.parse(data);
        }
        uploader: HttpUploader{}
        onUploadFinished: signalCenter.imageUploadFinished(caller, result);
    }

    HttpUploader {
        id: uploader;
        property variant caller: null;
        onUploadStateChanged: Script.uploadStateChanged();
    }

    AudioRecorder {
        id: recorder;
        outputLocation: utility.tempPath+"/audio.amr";
    }

    InfoBanner { id: infoBanner; }

    Component.onCompleted: {
        var msg = { "func": "initialize", "param": LocalStorage.openDatabaseSync};
        Worker.sendMessage(msg);
        Script.initialize(signalCenter, tbsettings, utility, Worker, uploader, imageUploader, LocalStorage.openDatabaseSync);
    }
    Component.onDestruction: utility.clearNotifications();
    cover: Qt.resolvedUrl("CoverPage.qml")

}

