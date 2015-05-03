import QtQuick 2.0
import Sailfish.Silica 1.0

Item{
    id: root

    property Item target
    property bool isShow: false
    property list<MenuItem> menuList

    onTargetChanged: {
        root.parent = target
    }

    function show(){
        isShow = true
    }

    function hide(){
        isShow = false
    }

    Rectangle{
        id: rect_mask
        anchors.fill: parent
        color: "black"
        opacity: isShow?0.5:0

        Behavior on opacity{
            NumberAnimation{duration: 500}
        }
    }

    ListView{
        id: list_menu

        width: parent.width/3
        height: parent.height
        x: isShow?root.width-list_menu.width:root.width
        spacing: 10

        Behavior on x{
            NumberAnimation{duration: 500}
        }

        model: ListModel{}
        delegate: Text{
            width: parent.width
            elide: Text.ElideRight
            text: menuItem.text
            color: Theme.highlightColor

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    menuItem.clicked(mouse);
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: {
            isShow = !isShow
        }
    }

    Component.onCompleted:{
        for(var i=0;i<menuList.length;++i){
            list_menu.model.append({menuItem: menuList[i]})
        }
    }
}
