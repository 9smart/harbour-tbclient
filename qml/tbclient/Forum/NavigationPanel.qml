import QtQuick 2.0
import Sailfish.Silica 1.0

import "../Component"

Panel {
    id: panel
    signal clicked
    MainBtnMenu{
        id: rightPanel
        mItemX: 2;
        mItemObjX: [{
                "btnName":"",
                "btnPic":"gfx/btn_refresh.png",
                "btnWidth":Screen.width*0.22,
            },{
                "btnName":"",
                "btnPic":"gfx/btn_edit.png",
                "btnWidth":Screen.width*0.22,
            }
        ];
        onBtnFunX: {
            switch(index){
            case 0://编辑
                internal.getlist();
                break;
            case 1://发帖
                var prop = { caller: internal };
                pageStack.push(Qt.resolvedUrl("../Post/PostPage.qml"), prop);
                break;
            default:
                break;
            }
        }

        mItemY: 4;
        mItemObjY: [{
                "btnName":qsTr("Boutique"),
            },{
                "btnName":qsTr("View photos"),
            },{
                "btnName":qsTr("Jump to page"),
            },{
                "btnName":qsTr("History"),
            },
        ];
        onBtnFunY: {
            switch(index){
            case 0://Boutique-精品
                internal.isGood = !internal.isGood;
                break;
            case 1://View photos-相册
                pageStack.replace(Qt.resolvedUrl("ForumPicture.qml"),{name: internal.getName()});
                break;
            case 2://Jump to page-跳转
                internal.jumpToPage();
                break;
            case 3://History-历史
                signalCenter.enterThread();;
                break;
            default:
                break;
            }
        }
    }

}
