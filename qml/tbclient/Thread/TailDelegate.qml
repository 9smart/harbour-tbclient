import QtQuick 2.0

Item {
    width: parent.width;
    height: width/15;
    Image{
        x:0;y:0;
        source: "../gfx/img_tail.png"
        width: parent.height*2;
        height: parent.height
    }
    Rectangle{
        color: "#f47920"
        x:parent.height*2;y:parent.height-height
        height: parent.height>45 ? 2 : 1
        width: parent.width-parent.height*2
    }

//f47920
}

