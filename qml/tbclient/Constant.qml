import QtQuick 2.0
import Sailfish.Silica 1.0
import "Base"

QtObject {
    id: constant;

    // color
    property color colorLight: Theme.highlightColor//tbsettings.whiteTheme ? "#191919" : "#ffffff";
    property color colorSecondaryLight: Theme.secondaryHighlightColor//tbsettings.whiteTheme ? "#191919" : "#ffffff";
    property color colorMid: Theme.primaryColor//tbsettings.whiteTheme ? "#505050" : "#d2d2d2";
    property color colorMarginLine: Theme.secondaryColor//tbsettings.whiteTheme ? "#a9a9a9" : "#444444";
    property color colorTextSelection: tbsettings.whiteTheme ? "#4591ff" : "#0072b2";
    property color colorDisabled: tbsettings.whiteTheme ? "#b2b2b4" : "#7f7f7f";

    // padding size
    property int paddingSmall: Theme.paddingSmall;
    property int paddingMedium: Theme.paddingMedium;
    property int paddingLarge: Theme.paddingLarge;
    property int paddingXLarge: 24;

    // graphic size
    property int graphicSizeTiny: Theme.fontSizeExtraSmall/3*4//32;
    property int graphicSizeSmall: Theme.fontSizeExtraSmall*2//48;
    property int graphicSizeMedium: Theme.fontSizeMedium*2//64;
    property int graphicSizeLarge: Theme.fontSizeLarge*2//80;
    property int thumbnailSize: Theme.fontSizeLarge*3//120;

    // font size
    property int fontXXSmall: Theme.fontSizeTiny;//20
    property int fontXSmall: Theme.fontSizeExtraSmall;
    property int fontSmall: Theme.fontSizeSmall;//24
    property int fontMedium: Theme.fontSizeMedium;//32
    property int fontLarge: Theme.fontSizeLarge;
    property int fontXLarge: Theme.fontSizeHuge;
    property int fontXXLarge: Theme.fontSizeExtraSmall;
    property variant subTitleFont: __subTitleText.font;
    property variant labelFont: __label.font;
    property variant titleFont: __titleText.font;

    // size
    property variant sizeTiny: Qt.size(graphicSizeTiny, graphicSizeTiny);
    property variant sizeMedium: Qt.size(graphicSizeMedium, graphicSizeMedium);

    // others
    property int headerHeight: app.inPortrait ? 72 : 56;
    property string invertedString: ".png"//tbsettings.whiteTheme ? ".png" : "_1.png";

    // private
    property Text __titleText: Text {
        font.pixelSize: fontMedium;
    }
    property Text __subTitleText: Text {
        font.pixelSize: fontSmall;
        font.weight: Font.Light;
    }
    property Text __label: Text {
        font.pixelSize: fontMedium;
    }
}
