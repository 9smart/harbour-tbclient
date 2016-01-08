import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Base"
Item {
    id: tabWidget
    default property alias content: stack.children //将tab页集合设置一个默认属性
    property int current: 0
    property bool tabTag: true
    onCurrentChanged: setOpacities()
    Component.onCompleted: setOpacities()
    function setOpacities() {
        for(var i = 0; i < content.length; ++i) {
            content[i].visible = (i == current ? true : false);
            content[i].opacity = (i == current ? 1 : 0);//将当前的tab设置为非透明,其余透明
        }
    }
    Row {  //此组件为tab选项
        id: header
        visible: tabTag;
        Repeater {
            model: content.length
            delegate: Rectangle {
                width: tabWidget.width / content.length
                height: 50;
                color: "#00e3e3e3"
//                Rectangle {  //此组件为tab选项和tab页之间的一条线
//                    width: tabWidget.width; height: 1
//                    anchors { bottom: parent.bottom; bottomMargin: 1}
//                    color: "#abc2c2"
//                }

                Rectangle{  //tab选项图片
                    anchors {
                        fill: parent;
//                        leftMargin: 2;
//                        topMargin: 5;
//                        rightMargin: 1;
                    }
                    //border { left: 7; right: 7}
                    //source: tabWidget.current == index? "tab.png" : "unselect.png"
                    color:tabWidget.current == index ? "#22ffffff" : "#22000000";

                }
                Text {  //tab选项的文本
                    anchors.fill: parent
                    horizontalAlignment: "AlignHCenter";
                    verticalAlignment: "AlignVCenter";
                    text: content[index].title
                    elide: Text.ElideRight
                    font.bold: tabWidget.current == index
                    color: constant.colorLight;
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: tabWidget.current = index  //存储当前选中tab页
                }
            }

        }
    }
    Item {  //此组件为tab页
        id: stack;
        width: tabWidget.width
        anchors.top: tabTag ? header.bottom :parent.top;
        anchors.bottom: tabWidget.bottom
        clip: true;
    }

}

