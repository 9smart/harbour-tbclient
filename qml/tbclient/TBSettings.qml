import QtQuick 2.0

QtObject {
    id: tbsettings;

    // system
    property string currentUid: utility.getValue("currentUid", "");
    onCurrentUidChanged: utility.setValue("currentUid", currentUid);

    property int clientType: utility.getValue("clientType", 1);
    onClientTypeChanged: utility.setValue("clientType", clientType);

    property string clientId: utility.getValue("clientId", "0");
    onClientIdChanged: utility.setValue("clientId", clientId);

    property string imagePath: utility.getValue("imagePath", utility.defaultPictureLocation);
    onImagePathChanged: utility.setValue("imagePath", imagePath);

    property string browser: utility.getValue("browser", "");
    onBrowserChanged: utility.setValue("browser", browser);

    property string signature: utility.getValue("signature", "");
    onSignatureChanged: utility.setValue("signature", signature);

    property bool monitorNetworkMode: utility.getValue("monitorNetworkMode", false) == "true";
    onMonitorNetworkModeChanged: utility.setValue("monitorNetworkMode", monitorNetworkMode);

    property string draftBox: utility.getValue("draftBox", "");
    onDraftBoxChanged: utility.setValue("draftBox", draftBox);

    property string currentBearerName;
    onCurrentBearerNameChanged: {
        console.log("currnet bearer:", currentBearerName);
        if (!monitorNetworkMode) return;
        switch (currentBearerName){
        case "2G":
        case "HSPA": {
            signalCenter.showMessage(qsTr("Mobile network used"));
            remindInterval = remindInterval == 0 ? 0 : Math.max(remindInterval, 5);
            remindBackground = false;
            showImage = false;
            break;
        }
        case "CDMA2000":
        case "WCDMA":
        case "WLAN": {
            signalCenter.showMessage(qsTr("High speed network used"));
            remindInterval = remindInterval == 0 ? 0 : Math.min(remindInterval, 1);
            remindBackground = true;
            showImage = true;
            break;
        }
        }
    }

    // design
    property bool whiteTheme: utility.getValue("whiteTheme", true) == "true";
    onWhiteThemeChanged: utility.setValue("whiteTheme", whiteTheme);

    property bool showImage: utility.getValue("showImage", true);
    onShowImageChanged: utility.setValue("showImage", showImage);

    property bool showAbstract: utility.getValue("showAbstract", true);
    onShowAbstractChanged: utility.setValue("showAbstract", showAbstract);

    property int maxTabCount: utility.getValue("maxTabCount", 4);
    onMaxTabCountChanged: utility.setValue("maxTabCount", maxTabCount);

    property int fontSize: utility.getValue("fontSize", constant.fontMedium);
    onFontSizeChanged: utility.setValue("fontSize", fontSize);

    property string bgImageUrl: utility.getValue("bgImageUrl", "");
    onBgImageUrlChanged: utility.setValue("bgImageUrl", bgImageUrl);

    // remind
    property int remindInterval: utility.getValue("remind/interval", 10);
    onRemindIntervalChanged: utility.setValue("remind/interval", remindInterval);

    property bool remindBackground: utility.getValue("remind/background", true) == "true";
    onRemindBackgroundChanged: utility.setValue("remind/background", remindBackground);

    property bool remindFans: utility.getValue("remind/fans", true) == "true";
    onRemindFansChanged: utility.setValue("remind/fans", remindFans);

    property bool remindPletter: utility.getValue("remind/pletter", true) == "true";
    onRemindPletterChanged: utility.setValue("remind/pletter", remindPletter);

    property bool remindBookmark: utility.getValue("remind/bookmark", false) == "true";
    onRemindBookmarkChanged: utility.setValue("remind/bookmark", remindBookmark);

    property bool remindReplyme: utility.getValue("remind/replyme", true) == "true";
    onRemindReplymeChanged: utility.setValue("remind/replyme", remindReplyme);

    property bool remindAtme: utility.getValue("remind/atme", true) == "true";
    onRemindAtmeChanged: utility.setValue("remind/atme", remindAtme);

    //屏蔽
    property string idList: utility.getValue("idList", "");
    onIdListChanged: utility.setValue("idList",idList);
    property bool onlyThead: utility.getValue("onlythead", false) == "true";
    onOnlyTheadChanged: utility.setValue("onlythead", onlyThead);
    property bool withPost: utility.getValue("withpost", false) == "true";
    onWithPostChanged: utility.setValue("withpost", withPost);


}
