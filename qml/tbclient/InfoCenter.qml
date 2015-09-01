import QtQuick 2.0
import com.yeatse.tbclient 1.0
//import org.nemomobile.notifications 1.0
import org.nemomobile.example 1.0
import "../js/main.js" as Script

Item {
    id: root;

    property int fans: 0;
    property int replyme: 0;
    property int atme: 0;
    property int pletter: 0;
    property int bookmark: 0;

    property bool loading: false;

    function clear(type){
        if (root.hasOwnProperty(type))
            root[type] = 0;
        internal.displayMessage();
    }

    enabled: false;

    Connections {
        target: signalCenter;
        onUserChanged: {
            root.enabled = true;
            processingTimer.triggered();
        }
        onUserLogout: {
            root.enabled = false;
        }
    }

    Connections {
        target: Qt.application;
        onActiveChanged: {
            if (!Qt.application.active){
                audioWrapper.stop();
            }
        }
    }
//    Notification{
//        id: notification
//        onClicked: {
//            app.activate();
//            console.log(pageStack[pageStack.depth])
//            pageStack.push(Qt.resolvedUrl("Message/MessagePage.qml"));

//        }
//    }

    Notification{
        id: notification

        category: "x-nemo.example"
        appName: qsTr("tbclient")
        appIcon: "gfx/icon-notice.png"
        remoteActions: [{
            "name": "default",
            "displayName": "hahahaha",
            "icon": "icon-s-do-it",
            "service": "org.tbclient",
            "path": "/service",
            "iface": "org.tbclient",
            "method": "doSomething",
            "arguments": [ "argument", 1 ]
        }]

        onActionInvoked:{
            console.log("clicked:"+actionKey)
            app.activate();

            if(body.indexOf(qsTr("fan"))>=0){
                console.log("open fan")
            }
//            if(body.indexOf(qsTr("pletter"))>=0){
//                console.log("open pletter")
//            }
            if(body.indexOf(qsTr("bookmark"))>=0){
                console.log("open bookmark")
            }
            if(body.indexOf(qsTr("reply"))>=0){
                console.log("open reply")
            }
            if(body.indexOf(qsTr("remind"))>=0){
                console.log("open remind")
            }
        }

        function getNotification(replacesId){
            var notificationList = notifications("tbclient")

            for(var i in notificationList){
                if(notificationList[i].replacesId == replacesId)
                    return notificationList[i]
            }
        }

        function showNotification(count, title, message){
            var notificationList = notifications("tbclient")

            for(var i in notificationList){
                if(notificationList[i].body == message
                        &&notificationList[i].itemCount==count)
                    return
            }
            itemCount = count
            summary = title
            previewSummary = title
            body = message
            previewBody = message
            clearNotifications()
            publish()
        }

        function clearNotifications(){
            var notificationList = notifications("tbclient")

            for(var i in notificationList){
                notificationList[i].close()
            }
        }
    }

    QtObject {
        id: internal;

        function loadMessage(obj){
            loading = false;
            for (var i in obj.message){
                if (root.hasOwnProperty(i)){
                    root[i] = Number(obj.message[i]);
                }
            }
            displayMessage();
        }

        function displayMessage(){
            var list = [], count = 0;
            if (fans > 0 && tbsettings.remindFans){
                list.push(qsTr("%n new fan(s)", "", fans));
                //signalCenter.showMessage(qsTr("%n new fan(s)", "", fans));
                count += fans;
            }
//            if (pletter > 0 && tbsettings.remindPletter){
//                list.push(qsTr("%n new pletter(s)", "", pletter));
//                //signalCenter.showMessage(qsTr("%n new pletter(s)", "", pletter));
//                count += pletter;
//            }
            if (bookmark > 0 && tbsettings.remindBookmark){
                list.push(qsTr("%n new bookmark update(s)", "", bookmark));
                //signalCenter.showMessage(qsTr("%n new bookmark update(s)", "", bookmark));
                count += bookmark;
            }
            if (replyme > 0 && tbsettings.remindReplyme){
                list.push(qsTr("%n new reply(ies)", "", replyme));
                //signalCenter.showMessage(qsTr("%n new reply(ies)", "", replyme));
                count += replyme;
            }
            if (atme > 0 && tbsettings.remindAtme){
                list.push(qsTr("%n new remind(s)", "", atme));
                //signalCenter.showMessage(qsTr("%n new remind(s)", "", atme));
                count += atme;
            }
            if (list.length > 0){
                var title = qsTr("Baidu Tieba");
                var message = list.join("\n");
//                notification.previewBody = title;
//                notification.previewSummary = message;
//                notification.publish();
                notification.showNotification(count, title, message);
            } else {
                notification.clearNotifications();


//                notification.previewBody = qsTr("Baidu Tieba");
//                notification.previewSummary = "15237";
//                notification.publish();
                //notification.close();
            }
        }

        function loadError(err){
            loading = false;
            console.log(err);
        }
    }

    Timer {
        id: processingTimer;
        interval: tbsettings.remindInterval * 60 * 1000;
        repeat: true;
        running: root.enabled
                 && tbsettings.remindInterval > 0
                 && (tbsettings.remindBackground||Qt.application.active);
        onTriggered: {
            loading = true;
            Script.getMessage(internal.loadMessage, internal.loadError);
        }
    }

}
