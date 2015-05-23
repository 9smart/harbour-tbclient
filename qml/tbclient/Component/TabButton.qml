import QtQuick 2.0
import Sailfish.Silica 1.0

IconButton{
    id:root
    icon.source: "image://theme/icon-m-tab"
    icon.anchors.horizontalCenterOffset: -(width-Theme.iconSizeMedium*2)/2+Theme.paddingMedium
    property string text: "";
    width: parent.width
    Label{
        anchors{
            left: parent.left;
            leftMargin: Theme.iconSizeMedium*3/2+Theme.paddingMedium*2;
            verticalCenter: parent.verticalCenter
        }
        text:root.text
    }
}
