import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id:root;
    property bool see: false;
    property int mItemY: 0;
    property int mItemX: 0;
    property var mItemObjY: [{
            "btnName":"",
        }
    ]
    property var mItemObjX: [{
            "btnName":"",
            "btnPic":"",
            "btnWidth":Screen.width*0.11
        }
    ]
    signal btnFunY(int index);
    signal btnFunX(int index);
    function open(){
        anim1.start();
    }
    function close(){
        anim2.start();
    }

    anchors{
        bottom: parent.bottom;
        right: parent.right;
        bottomMargin: 130;
        rightMargin: 50;
    }

    Item {
        id:columnIt
        opacity: 0;
        visible:see;
        anchors{
            right: mainBtn.left;
            bottom: mainBtn.top;
        }
        width:Screen.width*0.44;
        height: columnIt.width/3*mItemY;
        Rectangle{
            anchors.fill: parent;
            color: "#88000000";
        }
        Column {
            width: parent.width;
            height: parent.height;
            Repeater{
                id:rpy;
                model:mItemY
                Button {
                    anchors.right: parent.right;
                    text: root.mItemObjY[index].btnName;
                    onClicked: {
                        btnFunY(index);
                        root.close();
                    }
                }
            }
        }
    }
    Item {
        id:rowIt
        opacity: 0;
        visible:see;
        anchors{
            right: mainBtn.left;
            top: mainBtn.top;
        }
        height: mainBtn.height;
        width:Screen.width*0.44;
        //off
        Rectangle{
            anchors.fill: parent;
            color: "#88000000";
        }
        Row{
            width: parent.width;
            height: parent.height;

            Repeater{
                id:rpx;
                model:mItemX
                HeaderBtn {
                    anchors.margins: constant.paddingMedium;
                    hasBorder: true;
                    url: root.mItemObjX[index].btnPic;
                    txt: root.mItemObjX[index].btnName;
                    width: root.mItemObjX[index].btnWidth;
                    onTouched: {
                        btnFunX(index);
                        root.close();
                    }

                }
            }
        }
    }
    HeaderBtn{

        id:mainBtn;
        hasBorder: true;
        anchors.right:parent.right;
        col: "#88000000"
        url: "gfx/btn_more.png"
        onTouched: {
            if(columnIt.opacity==0){
                anim1.start();
            }else{
                columnIt.opacity=0;
                anim2.start();
            }
        }
    }
    SequentialAnimation {
        id:anim1
        ScriptAction { script: root.see=true; }
        NumberAnimation {
            targets: [columnIt,rowIt];
            properties: "opacity";
            from: 0;
            to:1;
            duration: 300;
        }
    }
    SequentialAnimation {
        id:anim2
        NumberAnimation {
            targets: [columnIt,rowIt];
            properties: "opacity";
            from: 1;
            to:0;
            duration: 300;
        }
        ScriptAction { script: root.see=false; }
    }
}
