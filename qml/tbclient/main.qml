import QtQuick 2.0
import Sailfish.Silica 1.0
import com.yeatse.tbclient 1.0
import QtQuick.LocalStorage 2.0
import io.thp.pyotherside 1.5
import "Component"
import "Base"
import "../js/main.js" as Script
import "../js/WorkerScript.js" as Worker

ApplicationWindow {
    id: app;
    property int allindex: 0
    property int num:0
    initialPage: MainPage { id: mainPage; }
//    FontLoader{id:myfont;source: "font/yayuan.ttf"}
//    FontLoader{id:myfont1;source: "font/DroidSansFallback.ttf"}
//    FontLoader{id:myfont2;source: "font/SourceHanSans-Normal.otf"}
//    FontLoader{id:myfont3;source: "font/DroidSansFallback-emoji.ttf"}
//    FontLoader{id:myfont4;source: "font/youyuan.ttf"}
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

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../python'))
            py.importModule('app', function () {

            })

            setHandler('log', function(msg){
                console.log(msg)
            })

            setHandler('error', function(msg){
                signalCenter.showMessage(qsTr(msg))
            })
        }
    }
    Component.onCompleted: {
        var msg = { "func": "initialize", "param": LocalStorage.openDatabaseSync};
        Worker.sendMessage(msg);
        Script.initialize(signalCenter, tbsettings, utility, Worker, uploader, imageUploader, LocalStorage.openDatabaseSync);
    }
    Component.onDestruction: utility.clearNotifications();
    cover: Qt.resolvedUrl("CoverPage.qml")

}

