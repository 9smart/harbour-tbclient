import QtQuick 2.0

Text {
    text: model.text;
    width: parent.width;
    wrapMode: Text.WrapAnywhere;
    font.pixelSize: constant.fontXSmall;
    color: constant.colorLight;
    linkColor: constant.colorLight;
    onLinkActivated: signalCenter.linkClicked(link);
}
