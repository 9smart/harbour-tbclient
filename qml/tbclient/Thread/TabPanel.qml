import QtQuick 2.1
import Sailfish.Silica 1.0

Item{
    width: parent.width/4
    height: parent.height

    default property alias content: tabBarLayout.data;
    property alias layout: tabBarLayout;

    Flickable{
        anchors.fill: parent
        contentHeight: tabBarLayout.height

        Column{
            id: tabBarLayout
        }
    }
}
